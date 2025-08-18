package org.example.startupecosystem.service;

import org.example.startupecosystem.entity.Investor;
import org.example.startupecosystem.repository.InvestorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class InvestorService {

    @Autowired
    private InvestorRepository investorRepository;

    public List<Investor> getAllInvestors() {
        return investorRepository.findAll();
    }

    public Optional<Investor> getInvestorById(Long id) {
        return investorRepository.findById(id);
    }

    /**
     * Updates the profile of an existing investor.
     * @param id The ID of the investor to update.
     * @param investorName The new investor name.
     * @param bio The new investor bio.
     * @param investmentPreferences The new investment preferences.
     * @return The updated Investor entity.
     * @throws RuntimeException if the investor is not found.
     */
    public Investor updateInvestorProfile(Long id, String investorName, String bio, String investmentPreferences) {
        // Find the existing investor record by its ID.
        // The orElseThrow() method will throw an exception if the investor is not found,
        // which prevents a NullPointerException.
        Investor investor = investorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Investor not found with id " + id));

        // Update the fields of the retrieved investor object with the new values.
        investor.setInvestorName(investorName);
        investor.setBio(bio);
        investor.setInvestmentPreferences(investmentPreferences);

        // Save the updated entity back to the database.
        return investorRepository.save(investor);
    }
}