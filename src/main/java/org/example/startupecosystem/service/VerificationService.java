package org.example.startupecosystem.service;

import org.example.startupecosystem.entity.Company;
import org.example.startupecosystem.entity.InvestorData;
import org.example.startupecosystem.repository.CompanyRepository;
import org.example.startupecosystem.repository.InvestorDataRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Optional;

@Service
public class VerificationService {

    @Autowired
    private CompanyRepository companyRepository;

    @Autowired
    private InvestorDataRepository investorDataRepository;

    public boolean verifyCompany(String companyName, String registrationNumber, String governmentId, Date foundingDate, String industry) {
        Optional<Company> company = companyRepository.findByCompanyNameAndRegistrationNumberAndGovernmentIdAndFoundingDateAndIndustry(
                companyName, registrationNumber, governmentId, foundingDate, industry);
                System.out.println("Verifying company: " + companyName + " with ID: " + governmentId);


        return company.isPresent();
    }

    public boolean verifyInvestor(String investorName, String investmentFirm) {
        Optional<InvestorData> investor = investorDataRepository.findByInvestorNameAndInvestmentFirm(investorName, investmentFirm);
        return investor.isPresent();
    }
}