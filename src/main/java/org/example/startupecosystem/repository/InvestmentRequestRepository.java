package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.InvestmentRequest;
import org.example.startupecosystem.entity.InvestmentRequestStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

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

    @Query("""
SELECT r FROM InvestmentRequest r
JOIN FETCH r.investor
JOIN FETCH r.startup
WHERE r.id = :id
""")
    InvestmentRequest findFullById(Long id);

    @Query("""
       SELECT COALESCE(SUM(ir.amount), 0)
       FROM InvestmentRequest ir
       WHERE ir.startup.id = :startupId
       AND ir.status = org.example.startupecosystem.entity.InvestmentRequestStatus.ACCEPTED
       """)
    Double getTotalAcceptedInvestmentByStartupId(@Param("startupId") Long startupId);

}
