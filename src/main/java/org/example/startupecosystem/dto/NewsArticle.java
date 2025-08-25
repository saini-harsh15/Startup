package org.example.startupecosystem.dto;

public class NewsArticle {
    private String title;
    private String url;
    private String imageUrl;

    public NewsArticle(String title, String url, String imageUrl) {
        this.title = title;
        this.url = url;
        this.imageUrl = imageUrl;
    }

    // getters and setters
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getUrl() {
        return url;
    }
    public void setUrl(String url) {
        this.url = url;
    }

    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
