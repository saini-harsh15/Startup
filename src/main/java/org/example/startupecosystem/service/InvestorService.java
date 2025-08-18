package org.example.startupecosystem.service;

import org.example.startupecosystem.entity.Investor;
import org.example.startupecosystem.repository.InvestorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class InvestorService {

    @Autowired
    private InvestorRepository investorRepository;

    public Investor updateInvestorProfile(Long id, String investorName, String bio, String investmentPreferences) {
        Investor investor = investorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Investor not found with id " + id));

        investor.setInvestorName(investorName);
        investor.setBio(bio);
        investor.setInvestmentPreferences(investmentPreferences);

        return investorRepository.save(investor);
    }
}