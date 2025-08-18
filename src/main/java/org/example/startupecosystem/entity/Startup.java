package org.example.startupecosystem.entity;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "startups")
public class Startup {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "email")
    private String email;

    @Column(name = "password")
    private String password;

    @Column(name = "name")
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "industry")
    private String industry;

    // New fields from the verification process
    @Column(name = "registration_number")
    private String registrationNumber;

    @Column(name = "government_id")
    private String governmentId;

    @Column(name = "founding_date")
    private Date foundingDate;
    
    @Column(name = "funding_ask")
    private Double fundingAsk;
    
    @Column(name = "equity_offered")
    private Double equityOffered;

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
    }

    // New Getters and Setters for the added fields
    public String getRegistrationNumber() {
        return registrationNumber;
    }

    public void setRegistrationNumber(String registrationNumber) {
        this.registrationNumber = registrationNumber;
    }

    public String getGovernmentId() {
        return governmentId;
    }

    public void setGovernmentId(String governmentId) {
        this.governmentId = governmentId;
    }

    public Date getFoundingDate() {
        return foundingDate;
    }

    public void setFoundingDate(Date foundingDate) {
        this.foundingDate = foundingDate;
    }
    
    public Double getFundingAsk() {
        return fundingAsk;
    }
    
    public void setFundingAsk(Double fundingAsk) {
        this.fundingAsk = fundingAsk;
    }
    
    public Double getEquityOffered() {
        return equityOffered;
    }
    
    public void setEquityOffered(Double equityOffered) {
        this.equityOffered = equityOffered;
    }
}