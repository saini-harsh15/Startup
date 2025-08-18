package org.example.startupecosystem.entity;

import jakarta.persistence.*;

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

    // New fields from the verification process
    @Column(name = "investor_name")
    private String investorName;

    @Column(name = "investment_firm")
    private String investmentFirm;
    
    @Column(name = "bio", columnDefinition = "TEXT")
    private String bio;
    
    @Column(name = "investment_preferences", columnDefinition = "TEXT")
    private String investmentPreferences;

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

    // New Getters and Setters for the added fields
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

    /**
     * Updates the investor's profile with new information.
     * @param investorName The new name of the investor.
     * @param bio The investor's bio or description.
     * @param investmentPreferences The investor's investment preferences.
     */
    public void updateProfile(String investorName, String bio, String investmentPreferences) {
        this.investorName = investorName;
        this.bio = bio;
        this.investmentPreferences = investmentPreferences;
    }
}