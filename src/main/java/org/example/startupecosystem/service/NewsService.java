package org.example.startupecosystem.service;

import org.example.startupecosystem.dto.NewsArticle;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class NewsService {

    private final String apiKey;
    private final String baseUrl;
    private final RestTemplate restTemplate;

    // Constructor Injection (recommended)
    public NewsService(
            @Value("${news.api.key}") String apiKey,
            @Value("${news.api.base-url}") String baseUrl
    ) {
        this.apiKey = apiKey;
        this.baseUrl = baseUrl;
        this.restTemplate = new RestTemplate();
    }

    public List<NewsArticle> fetchNews(String industry) {
        String topic = normalizeIndustry(industry);
        String query = buildQueryForIndustry(topic);
        return executeQuery(query, 10);
    }

    private List<NewsArticle> executeQuery(String query, int max) {
        List<NewsArticle> articles = new ArrayList<>();

        try {
            URI uri = UriComponentsBuilder
                    .fromHttpUrl(baseUrl)
                    .queryParam("q", query)
                    .queryParam("lang", "en")
                    .queryParam("max", max)
                    .queryParam("apikey", apiKey)
                    .build()
                    .toUri();

            Map<String, Object> response =
                    restTemplate.getForObject(uri, Map.class);

            if (response != null && response.containsKey("articles")) {
                List<Map<String, Object>> newsList =
                        (List<Map<String, Object>>) response.get("articles");

                for (Map<String, Object> item : newsList) {

                    String title = (String) item.getOrDefault("title", "");
                    String link = (String) item.getOrDefault("url", "");
                    String imageUrl = (String) item.getOrDefault("image", "");

                    if (title != null && link != null &&
                            !title.isEmpty() && !link.isEmpty()) {

                        articles.add(new NewsArticle(title, link, imageUrl));
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return articles;
    }

    private String buildQueryForIndustry(String industry) {

        String key = industry == null ? "startup"
                : industry.trim().toLowerCase();

        Map<String, String> map = new HashMap<>();

        map.put("ai",
                "(AI OR \"artificial intelligence\" OR machine learning OR ML)");

        map.put("fintech",
                "(fintech OR \"financial technology\" OR payments OR banking)");

        map.put("healthcare",
                "(healthtech OR healthcare OR \"digital health\")");

        String industryTerms = map.getOrDefault(
                key,
                "(\"" + escape(key) + "\" OR " + escape(key) + ")"
        );

        String startupContext =
                "(startup OR startups OR venture OR funding OR \"series a\" OR seed)";

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