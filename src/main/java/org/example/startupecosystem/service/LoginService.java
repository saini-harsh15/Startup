package org.example.startupecosystem.service;

import org.example.startupecosystem.entity.Investor;
import org.example.startupecosystem.entity.Startup;
import org.example.startupecosystem.repository.InvestorRepository;
import org.example.startupecosystem.repository.StartupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class LoginService {

    @Autowired
    private StartupRepository startupRepository;

    @Autowired
    private InvestorRepository investorRepository;

    @Autowired
    private PasswordEncoder passwordEncoder; // Autowire the password encoder

    public String[] authenticate(String email, String password) {
        // Try to find a startup by email first
        Optional<Startup> startupOptional = startupRepository.findByEmail(email);
        if (startupOptional.isPresent()) {
            Startup startup = startupOptional.get();
            // Use passwordEncoder.matches() to safely compare the plain-text password with the hashed one
            if (passwordEncoder.matches(password, startup.getPassword())) {
                return new String[]{"Startup", String.valueOf(startup.getId())};
            }
        }

        // If not a startup, try to find an investor by email
        Optional<Investor> investorOptional = investorRepository.findByEmail(email);
        if (investorOptional.isPresent()) {
            Investor investor = investorOptional.get();
            // Use passwordEncoder.matches() to safely compare the plain-text password with the hashed one
            if (passwordEncoder.matches(password, investor.getPassword())) {
                return new String[]{"Investor", String.valueOf(investor.getId())};
            }
        }

        return null;
    }
}
