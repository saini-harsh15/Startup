package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.InvestorData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface InvestorDataRepository extends JpaRepository<InvestorData, Long> {

    Optional<InvestorData> findByInvestorNameAndInvestmentFirm(String investorName, String investmentFirm);
}