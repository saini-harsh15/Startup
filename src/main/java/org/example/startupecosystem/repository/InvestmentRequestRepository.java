package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.InvestmentRequest;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InvestmentRequestRepository
        extends JpaRepository<InvestmentRequest, Long> {
}
