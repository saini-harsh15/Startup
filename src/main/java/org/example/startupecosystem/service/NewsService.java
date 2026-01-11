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

    private static final String API_KEY = "214e6d80fc81454dd83ac558dffc5d95"; // 🚀 Replace with your GNews key
    private static final String BASE_URL = "https://gnews.io/api/v4/search";

    private final RestTemplate restTemplate;

    public NewsService() {
        this.restTemplate = new RestTemplate();
        this.restTemplate.setUriTemplateHandler(new DefaultUriBuilderFactory(BASE_URL));
    }

    public List<NewsArticle> fetchNews(String industry) {
        List<NewsArticle> articles = new ArrayList<>();

        String topic = normalizeIndustry(industry);
        String query = buildQueryForIndustry(topic);

        articles = executeQuery(query, 10);

        return articles;
    }

    private List<NewsArticle> executeQuery(String query, int max) {
        List<NewsArticle> articles = new ArrayList<>();
        try {
            URI uri = new DefaultUriBuilderFactory(BASE_URL)
                    .builder()
                    .queryParam("q", query)
                    .queryParam("lang", "en")
                    .queryParam("max", max) // max articles per request
                    .queryParam("apikey", API_KEY)
                    .build();

            Map<String, Object> response = restTemplate.getForObject(uri, Map.class);
            if (response != null && response.containsKey("articles")) {
                List<Map<String, Object>> newsList = (List<Map<String, Object>>) response.get("articles");
                for (Map<String, Object> item : newsList) {
                    String title = (String) item.getOrDefault("title", "");
                    String link = (String) item.getOrDefault("url", "");
                    String imageUrl = (String) item.getOrDefault("image", "");
                    if (title != null && link != null && !title.isEmpty() && !link.isEmpty()) {
                        articles.add(new NewsArticle(title, link, imageUrl));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Logging only; UI can handle empty
        }
        return articles;
    }

    private String buildQueryForIndustry(String industry) {
        // Keep your same advanced query logic
        String key = industry == null ? "startup" : industry.trim().toLowerCase();
        Map<String, String> map = new HashMap<>();
        map.put("ai", "(AI OR \"artificial intelligence\" OR machine learning OR ML)");
        map.put("fintech", "(fintech OR \"financial technology\" OR payments OR banking)");
        map.put("healthcare", "(healthtech OR healthcare OR \"digital health\")");
        // (keep all other industry mappings)

        String industryTerms = map.getOrDefault(key, "(\"" + escape(key) + "\" OR " + escape(key) + ")");
        String startupContext = "(startup OR startups OR venture OR funding OR \"series a\" OR seed)";
        return String.format("%s AND %s", industryTerms, startupContext);
    }

    private String normalizeIndustry(String industry) {
        if (industry == null) return "startup";
        String s = industry.trim();
        return s.isEmpty() ? "startup" : s;
    }

    private String escape(String term) {
        return term.replace("\"", "\\\"");
    }
}
