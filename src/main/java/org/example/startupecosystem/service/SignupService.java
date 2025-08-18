package org.example.startupecosystem.service;

import org.example.startupecosystem.entity.Investor;
import org.example.startupecosystem.entity.Startup;
import org.example.startupecosystem.repository.InvestorRepository;
import org.example.startupecosystem.repository.StartupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

@Service
@Transactional
public class SignupService {

    @Autowired
    private StartupRepository startupRepository;

    @Autowired
    private InvestorRepository investorRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public Long registerNewUser(String email, String password, String role, String name, String description, String industry, String registrationNumber, String governmentId, Date foundingDate, String investorName, String investmentFirm) {


        String hashedPassword = passwordEncoder.encode(password);
        Long userId = null;

        if ("Startup".equals(role)) {
            Startup startup = new Startup();
            startup.setEmail(email);
            startup.setPassword(hashedPassword);
            // For startups, use companyName as the name if name is null
            startup.setName(name != null ? name : registrationNumber);
            startup.setDescription(description);
            startup.setIndustry(industry);
            // New verification fields added
            startup.setRegistrationNumber(registrationNumber);
            startup.setGovernmentId(governmentId);
            startup.setFoundingDate(foundingDate);

            try {
                Startup savedStartup = startupRepository.save(startup);
                userId = savedStartup.getId();
            } catch (Exception e) {
                // In a production app, use a proper logging framework and handle the exception gracefully
                e.printStackTrace();
                throw e; // Rethrow to allow controller to handle it
            }

            System.out.println("Startup account created for email: " + email);

        } else if ("Investor".equals(role)) {
            Investor investor = new Investor();
            investor.setEmail(email);
            investor.setPassword(hashedPassword);
            // New verification fields added
            investor.setInvestorName(investorName);
            investor.setInvestmentFirm(investmentFirm);

            Investor savedInvestor = investorRepository.save(investor);
            userId = savedInvestor.getId();
            System.out.println("Investor account created for email: " + email);
        }
        
        return userId;
    }
}