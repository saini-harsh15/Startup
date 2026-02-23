package org.example.startupecosystem.dto;

import java.time.LocalDateTime;

public class ProfileViewerAnalyticsDTO {

    private Long investorId;
    private String investorName;
    private String investorType;
    private long totalVisits;
    private LocalDateTime lastViewedAt;
    private int score;
    private String temperature;
    private String lastSeenText;

    public ProfileViewerAnalyticsDTO(Long investorId,
                                     String investorName,
                                     String investorType,
                                     long totalVisits,
                                     LocalDateTime lastViewedAt,
                                     int score,
                                     String temperature,
                                     String lastSeenText) {

        this.investorId = investorId;
        this.investorName = investorName;
        this.investorType = investorType;
        this.totalVisits = totalVisits;
        this.lastViewedAt = lastViewedAt;
        this.score = score;
        this.temperature = temperature;
        this.lastSeenText = lastSeenText;
    }

    public Long getInvestorId() { return investorId; }
    public String getInvestorName() { return investorName; }
    public String getInvestorType() { return investorType; }
    public long getTotalVisits() { return totalVisits; }
    public LocalDateTime getLastViewedAt() { return lastViewedAt; }
    public int getScore() { return score; }
    public String getTemperature() { return temperature; }
    public String getLastSeenText() { return lastSeenText; }
}
