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

    public Long registerNewUser(
            String email,
            String password,
            String role,
            String name,
            String description,
            String industry,
            String registrationNumber,
            String governmentId,
            Date foundingDate,
            Double fundingAsk,
            Double equityOffered,
            String investorName,
            String investmentFirm
    ) {

        String hashedPassword = passwordEncoder.encode(password);

        if ("Startup".equalsIgnoreCase(role)) {
            Startup startup = new Startup();
            startup.setEmail(email);
            startup.setPassword(hashedPassword);
            startup.setName(name);
            startup.setDescription(description);
            startup.setIndustry(industry);
            startup.setRegistrationNumber(registrationNumber);
            startup.setGovernmentId(governmentId);
            startup.setFoundingDate(foundingDate);
            startup.setFundingAsk(fundingAsk);
            startup.setEquityOffered(equityOffered);

            return startupRepository.save(startup).getId();
        }

        if ("Investor".equalsIgnoreCase(role)) {
            Investor investor = new Investor();
            investor.setEmail(email);
            investor.setPassword(hashedPassword);
            investor.setInvestorName(investorName);
            investor.setInvestmentFirm(investmentFirm);

            return investorRepository.save(investor).getId();
        }

        throw new IllegalArgumentException("Invalid role: " + role);
    }
}
