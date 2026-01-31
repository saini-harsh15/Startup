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
        // Normalize inputs
        String normalizedEmail = email == null ? null : email.trim();
        String rawPassword = password == null ? "" : password;

        // Try to find a startup by email first
        Optional<Startup> startupOptional = startupRepository.findByEmail(normalizedEmail);
        if (startupOptional.isPresent()) {
            Startup startup = startupOptional.get();
            String stored = startup.getPassword();
            // Compare using encoder
            if (stored != null && passwordEncoder.matches(rawPassword, stored)) {
                return new String[]{"Startup", String.valueOf(startup.getId())};
            }
            // Backward compatibility: if password was historically stored in plain text
            if (stored != null && !isBcryptHash(stored) && stored.equals(rawPassword)) {
                // Migrate to encoded on-the-fly
                startup.setPassword(passwordEncoder.encode(rawPassword));
                startupRepository.save(startup);
                return new String[]{"Startup", String.valueOf(startup.getId())};
            }
        }

        // If not a startup, try to find an investor by email
        Optional<Investor> investorOptional = investorRepository.findByEmail(normalizedEmail);
        if (investorOptional.isPresent()) {
            Investor investor = investorOptional.get();
            String stored = investor.getPassword();
            if (stored != null && passwordEncoder.matches(rawPassword, stored)) {
                return new String[]{"Investor", String.valueOf(investor.getId())};
            }
            // Backward compatibility for investors too
            if (stored != null && !isBcryptHash(stored) && stored.equals(rawPassword)) {
                investor.setPassword(passwordEncoder.encode(rawPassword));
                investorRepository.save(investor);
                return new String[]{"Investor", String.valueOf(investor.getId())};
            }
        }

        return null;
    }

    private boolean isBcryptHash(String value) {
        return value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$");
    }
}
