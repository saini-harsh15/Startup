package org.example.startupecosystem.service;

import org.example.startupecosystem.dto.NewsArticle;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.DefaultUriBuilderFactory;

import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class NewsService {

    // 🔑 Replace with your real API key
    private static final String API_KEY = "3e7956ca646541639f680e5aeaf6ee6f";
    private static final String BASE_URL = "https://newsapi.org/v2/everything";

    private final RestTemplate restTemplate;

    public NewsService() {
        // Create RestTemplate with DefaultUriBuilderFactory
        this.restTemplate = new RestTemplate();
        this.restTemplate.setUriTemplateHandler(new DefaultUriBuilderFactory(BASE_URL));
    }

    /**
     * Fetch recent, domain-relevant startup news for a given industry/domain.
     * Builds a richer query that combines the industry with startup context terms
     * to avoid random, off-topic results from generic keywords.
     */
    public List<NewsArticle> fetchNews(String industry) {
        List<NewsArticle> articles = new ArrayList<>();

        String topic = normalizeIndustry(industry);
        String primaryQuery = buildQueryForIndustry(topic);

        // First attempt: industry keywords + startup context
        articles = executeQuery(primaryQuery, 20);

        // Fallback: if nothing found, try a simpler query that still biases to startups
        if (articles.isEmpty()) {
            String fallbackQuery = String.format("(%s) AND (startup OR startups OR venture OR funding)", escape(topic));
            articles = executeQuery(fallbackQuery, 20);
        }

        return articles;
    }

    private List<NewsArticle> executeQuery(String query, int pageSize) {
        List<NewsArticle> articles = new ArrayList<>();
        try {
            URI uri = new DefaultUriBuilderFactory(BASE_URL)
                    .builder()
                    .queryParam("q", query)
                    .queryParam("language", "en")
                    .queryParam("searchIn", "title,description")
                    .queryParam("sortBy", "publishedAt")
                    .queryParam("pageSize", pageSize)
                    .queryParam("apiKey", API_KEY)
                    .build();

            Map<String, Object> response = restTemplate.getForObject(uri, Map.class);
            if (response != null && response.containsKey("articles")) {
                List<Map<String, Object>> newsList = (List<Map<String, Object>>) response.get("articles");
                for (Map<String, Object> item : newsList) {
                    String title = (String) item.getOrDefault("title", "");
                    String link = (String) item.getOrDefault("url", "");
                    String imageUrl = (String) item.getOrDefault("urlToImage", "");
                    if (title != null && link != null && !title.isEmpty() && !link.isEmpty()) {
                        articles.add(new NewsArticle(title, link, imageUrl));
                    }
                }
            }
        } catch (Exception e) {
            // swallow and return what we have; UI handles empty state
            e.printStackTrace();
        }
        return articles;
    }

    private String buildQueryForIndustry(String industry) {
        String key = industry == null ? "startup" : industry.trim().toLowerCase();
        Map<String, String> map = new HashMap<>();
        map.put("ai", "(AI OR \"artificial intelligence\" OR machine learning OR ML)");
        map.put("artificial intelligence", "(AI OR \"artificial intelligence\" OR machine learning OR ML)");
        map.put("fintech", "(fintech OR \"financial technology\" OR payments OR banking)");
        map.put("healthcare", "(healthtech OR healthcare OR \"digital health\" OR medtech)");
        map.put("edtech", "(edtech OR education OR e-learning OR \"learning platform\")");
        map.put("e-commerce", "(e-commerce OR ecommerce OR retail tech OR marketplace)");
        map.put("saas", "(SaaS OR \"software as a service\")");
        map.put("blockchain", "(blockchain OR crypto OR web3 OR defi)");
        map.put("clean energy", "(clean energy OR renewable OR solar OR wind OR climate tech)");
        map.put("climate", "(climate tech OR clean energy OR decarbonization)");
        map.put("biotech", "(biotech OR \"biotechnology\" OR life sciences)");
        map.put("agritech", "(agritech OR agriculture OR agri-tech)");
        map.put("cybersecurity", "(cybersecurity OR infosec OR security)");

        String industryTerms = map.getOrDefault(key, "(\"" + escape(key) + "\" OR " + escape(key) + ")");
        String startupContext = "(startup OR startups OR venture OR funding OR \"series a\" OR seed OR accelerator)";
        return String.format("%s AND %s", industryTerms, startupContext);
    }

    private String normalizeIndustry(String industry) {
        if (industry == null) return "startup";
        String s = industry.trim();
        if (s.isEmpty()) return "startup";
        return s;
    }

    private String escape(String term) {
        return term.replace("\"", "\\\"");
    }
}
