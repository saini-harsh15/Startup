package org.example.startupecosystem.service;

import org.example.startupecosystem.entity.Startup;
import org.example.startupecosystem.repository.StartupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class StartupService {

    @Autowired
    private StartupRepository startupRepository;

    public Optional<Startup> getStartupById(Long id) {
        return startupRepository.findById(id);
    }

    /**
     * Retrieves an unfiltered list of all Startup entities.
     * This is useful for general listings (like on the Investor dashboard load).
     */
    public List<Startup> findAll() {
        return startupRepository.findAll();
    }

    public List<Startup> findStartupsByCriteria(String search, String industry) {
        return startupRepository.findBySearchCriteria(search, industry);
    }

    public List<String> getDistinctIndustries() {
        return startupRepository.findDistinctIndustries();
    }

    public Startup updateStartupProfile(Long id, String name, String description, String industry) {
        Startup startup = startupRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Startup not found with id " + id));
        startup.setName(name);
        startup.setDescription(description);
        startup.setIndustry(industry);
        return startupRepository.save(startup);
    }
}