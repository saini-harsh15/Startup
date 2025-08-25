package org.example.startupecosystem.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "investors")
public class Investor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "email")
    private String email;
 
    @Column(name = "password")
    private String password;

    @Column(name = "investor_name")
    private String investorName;

    @Column(name = "investment_firm")
    private String investmentFirm;

    @Column(name = "bio")
    private String bio;

    @Column(name = "investment_preferences")
    private String investmentPreferences;

    @Column(name = "investor_type")
    private String investorType;

    @Column(name = "preferred_domains")
    private String preferredDomains;

    @Column(name = "funding_stages")
    private String fundingStages;

    @Column(name = "notable_investments")
    private String notableInvestments;

    @Column(name = "location")
    private String location;

    @Column(name = "website")
    private String website;

    @Column(name = "investment_range_usd")
    private String investmentRangeUsd;

    @Column(name = "linkedin")
    private String linkedin;

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

    public String getInvestorName() {
        return investorName;
    }

    public void setInvestorName(String investorName) {
        this.investorName = investorName;
    }

    public String getInvestmentFirm() {
        return investmentFirm;
    }

    public void setInvestmentFirm(String investmentFirm) {
        this.investmentFirm = investmentFirm;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getInvestmentPreferences() {
        return investmentPreferences;
    }

    public void setInvestmentPreferences(String investmentPreferences) {
        this.investmentPreferences = investmentPreferences;
    }

    public String getInvestorType() {
        return investorType;
    }

    public void setInvestorType(String investorType) {
        this.investorType = investorType;
    }

    public String getPreferredDomains() {
        return preferredDomains;
    }

    public void setPreferredDomains(String preferredDomains) {
        this.preferredDomains = preferredDomains;
    }

    public String getFundingStages() {
        return fundingStages;
    }

    public void setFundingStages(String fundingStages) {
        this.fundingStages = fundingStages;
    }

    public String getNotableInvestments() {
        return notableInvestments;
    }

    public void setNotableInvestments(String notableInvestments) {
        this.notableInvestments = notableInvestments;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getInvestmentRangeUsd() {
        return investmentRangeUsd;
    }

    public void setInvestmentRangeUsd(String investmentRangeUsd) {
        this.investmentRangeUsd = investmentRangeUsd;
    }

    public String getLinkedin() {
        return linkedin;
    }

    public void setLinkedin(String linkedin) {
        this.linkedin = linkedin;
    }
}