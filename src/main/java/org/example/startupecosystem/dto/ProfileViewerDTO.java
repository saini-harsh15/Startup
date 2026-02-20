package org.example.startupecosystem.dto;

import java.time.LocalDateTime;

public class ProfileViewerDTO {

    private Long investorId;
    private String investorName;
    private String investorType;
    private LocalDateTime viewedAt;

    public ProfileViewerDTO(Long investorId, String investorName, String investorType, LocalDateTime viewedAt) {
        this.investorId = investorId;
        this.investorName = investorName;
        this.investorType = investorType;
        this.viewedAt = viewedAt;
    }

    public Long getInvestorId() { return investorId; }
    public String getInvestorName() { return investorName; }
    public String getInvestorType() { return investorType; }
    public LocalDateTime getViewedAt() { return viewedAt; }
}
