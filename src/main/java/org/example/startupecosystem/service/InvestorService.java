package org.example.startupecosystem.service;

import org.example.startupecosystem.entity.Investor;
import org.example.startupecosystem.repository.InvestorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Sort; // <-- Add this import

import java.util.List;
import java.util.Optional;

@Service
public class InvestorService {

    @Autowired
    private InvestorRepository investorRepository;

    public Optional<Investor> getInvestorById(Long id) {
        return investorRepository.findById(id);
    }

    // Updated method for more flexible search and sort
    public List<Investor> findInvestorsByCriteria(String search, String sort) {
        // Handle sorting if a sort parameter is provided
        if (sort != null && !sort.isEmpty()) {
            if (search != null && !search.isEmpty()) {
                // If both search and sort are present, filter then sort
                return investorRepository.findBySearchCriteria(search, Sort.by(sort));
            } else {
                // If only sort is present, get all and sort
                return investorRepository.findAll(Sort.by(sort));
            }
        } else if (search != null && !search.isEmpty()) {
            // If only search is present, filter without sorting
            return investorRepository.findBySearchCriteria(search, Sort.unsorted());
        }

        // Default: return all investors without any filters or sorting
        return investorRepository.findAll();
    }

    public List<String> getDistinctPreferredDomains() {
        return investorRepository.findDistinctPreferredDomains();
    }

    public Investor updateInvestorProfile(Long id, String investorName, String bio, String investmentPreferences) {
        Investor investor = investorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Investor not found with id " + id));

        investor.setInvestorName(investorName);
        investor.setBio(bio);
        investor.setInvestmentPreferences(investmentPreferences);

        return investorRepository.save(investor);
    }
}