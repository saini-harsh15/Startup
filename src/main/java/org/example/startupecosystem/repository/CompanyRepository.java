package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.Company;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.Optional;

public interface CompanyRepository extends JpaRepository<Company, Long> {
    Optional<Company> findByCompanyNameAndRegistrationNumberAndGovernmentIdAndFoundingDateAndIndustry(
            String companyName,
            String registrationNumber,
            String governmentId,
            Date foundingDate, // The data type has been changed to Date
            String industry);
}