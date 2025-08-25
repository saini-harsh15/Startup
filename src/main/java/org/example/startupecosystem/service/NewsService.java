package org.example.startupecosystem.service;

import org.example.startupecosystem.dto.NewsArticle;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.DefaultUriBuilderFactory;

import java.net.URI;
import java.util.ArrayList;
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

    public List<NewsArticle> fetchNews(String industry) {
        List<NewsArticle> articles = new ArrayList<>();

        try {
            URI uri = new DefaultUriBuilderFactory(BASE_URL)
                    .builder()
                    .queryParam("q", industry)
                    .queryParam("language", "en")
                    .queryParam("sortBy", "publishedAt")
                    .queryParam("apiKey", API_KEY)
                    .build();

            Map<String, Object> response = restTemplate.getForObject(uri, Map.class);

            if (response != null && response.containsKey("articles")) {
                List<Map<String, Object>> newsList = (List<Map<String, Object>>) response.get("articles");

                for (Map<String, Object> item : newsList) {
                    String title = (String) item.get("title");
                    String link = (String) item.get("url");
                    String imageUrl = (String) item.get("urlToImage");

                    articles.add(new NewsArticle(title, link ,imageUrl));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return articles;
    }
}
