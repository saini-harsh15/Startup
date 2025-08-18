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

    @Column(name = "investor_name")
    private String investorName;

    @Column(name = "investment_firm")
    private String investmentFirm;

    // Add these new fields
    @Column(name = "bio")
    private String bio;

    @Column(name = "investment_preferences")
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

    // Add getters and setters for new fields
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
}