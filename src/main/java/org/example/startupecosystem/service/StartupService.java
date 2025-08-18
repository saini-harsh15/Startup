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

    public List<Startup> getAllStartups() {
        return startupRepository.findAll();
    }

    public Optional<Startup> getStartupById(Long id) {
        return startupRepository.findById(id);
    }

    /**
     * Updates the profile of an existing startup.
     * @param id The ID of the startup to update.
     * @param name The new company name.
     * @param description The new company description.
     * @param industry The new industry.
     * @return The updated Startup entity.
     * @throws RuntimeException if the startup is not found.
     */
    public Startup updateStartupProfile(Long id, String name, String description, String industry) {
        // Find the existing startup record by its ID.
        // The orElseThrow() method will throw an exception if the startup is not found,
        // which prevents a NullPointerException.
        Startup startup = startupRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Startup not found with id " + id));

        // Update the fields of the retrieved startup object with the new values.
        startup.setName(name);
        startup.setDescription(description);
        startup.setIndustry(industry);

        // Save the updated entity back to the database.
        return startupRepository.save(startup);
    }
}