package org.example.startupecosystem.dto;

public class InvestmentRequestNotificationDTO {

    private Long id;
    private String investorName;
    private Double amount;
    private String fundingStage;
    private String status;
    private Long investorId;

    public InvestmentRequestNotificationDTO(Long id, String investorName, Double amount,
                                            String fundingStage, String status, Long investorId) {
        this.id = id;
        this.investorName = investorName;
        this.amount = amount;
        this.fundingStage = fundingStage;
        this.status = status;
        this.investorId = investorId;
    }

    public Long getId() { return id; }
    public String getInvestorName() { return investorName; }
    public Double getAmount() { return amount; }
    public String getFundingStage() { return fundingStage; }
    public String getStatus() { return status; }
    public Long getInvestorId() { return investorId; }
}