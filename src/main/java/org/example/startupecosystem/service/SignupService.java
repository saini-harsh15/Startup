package org.example.startupecosystem.service;

import org.example.startupecosystem.entity.Investor;
import org.example.startupecosystem.entity.Startup;
import org.example.startupecosystem.repository.InvestorRepository;
import org.example.startupecosystem.repository.StartupRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.example.startupecosystem.util.PasswordValidator;
import org.springframework.dao.DataIntegrityViolationException;



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

    private void validateEmailNotTaken(String email) {
        if (startupRepository.existsByEmail(email) || investorRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("Email already registered");
        }
    }

    public boolean emailExists(String email) {
        return startupRepository.existsByEmail(email) || investorRepository.existsByEmail(email);
    }



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

        // 🔒 PASSWORD VALIDATION
        if (!PasswordValidator.isValid(password)) {
            throw new IllegalArgumentException(
                    "Password must be at least 10 characters long and include uppercase, lowercase and a number. No spaces allowed."
            );
        }

        validateEmailNotTaken(email);
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

            try {
                return startupRepository.save(startup).getId();
            } catch (DataIntegrityViolationException e) {
                throw new IllegalArgumentException("Email already registered");
            }

        }

        if ("Investor".equalsIgnoreCase(role)) {
            Investor investor = new Investor();
            investor.setEmail(email);
            investor.setPassword(hashedPassword);
            investor.setInvestorName(investorName);
            investor.setInvestmentFirm(investmentFirm);

            try {
                return investorRepository.save(investor).getId();
            } catch (DataIntegrityViolationException e) {
                throw new IllegalArgumentException("Email already registered");
            }

        }

        throw new IllegalArgumentException("Invalid role: " + role);
    }
}
