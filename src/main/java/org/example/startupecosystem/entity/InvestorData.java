package org.example.startupecosystem.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "investor_verification_data")
public class InvestorData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "investor_name", nullable = false)
    private String investorName;

    @Column(name = "investment_firm")
    private String investmentFirm;

    @Column(name = "years_of_experience")
    private Integer yearsOfExperience;

    @Column(name = "preferred_industry")
    private String preferredIndustry;

    // Default constructor is required by JPA
    public InvestorData() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public Integer getYearsOfExperience() {
        return yearsOfExperience;
    }

    public void setYearsOfExperience(Integer yearsOfExperience) {
        this.yearsOfExperience = yearsOfExperience;
    }

    public String getPreferredIndustry() {
        return preferredIndustry;
    }

    public void setPreferredIndustry(String preferredIndustry) {
        this.preferredIndustry = preferredIndustry;
    }
}