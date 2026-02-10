package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.InvestmentRequest;
import org.example.startupecosystem.entity.InvestmentRequestStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InvestmentRequestRepository
        extends JpaRepository<InvestmentRequest, Long> {

    // Existing – keep
    List<InvestmentRequest> findByStartupIdOrderByCreatedAtDesc(Long startupId);

    // NEW – for dashboard metrics
    long countByStartupIdAndStatus(Long startupId, InvestmentRequestStatus status);

    // NEW – for accepted investments
    List<InvestmentRequest> findByStartupIdAndStatusOrderByCreatedAtDesc(
            Long startupId,
            InvestmentRequestStatus status
    );
}
