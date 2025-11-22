package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.Investor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Sort;

import java.util.List;
import java.util.Optional;

@Repository
public interface InvestorRepository extends JpaRepository<Investor, Long> {

    Optional<Investor> findByEmail(String email);

    // Standard method inherited from JpaRepository, often added for clarity.
    Optional<Investor> findById(Long id);

    /**
     * Searches investors by name, preferred domain, or investor type.
     * Logic Fix: Simplified the WHERE clause to remove redundant NULL checks.
     */
    @Query("SELECT i FROM Investor i WHERE " +
            "(:search IS NULL OR :search = '' OR " +
            "LOWER(i.investorName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(i.preferredDomains) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(i.investorType) LIKE LOWER(CONCAT('%', :search, '%')))")
    List<Investor> findBySearchCriteria(@Param("search") String search);

    /**
     * Searches investors with sorting applied.
     */
    @Query("SELECT i FROM Investor i WHERE " +
            "(:search IS NULL OR :search = '' OR " +
            "LOWER(i.investorName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(i.preferredDomains) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(i.investorType) LIKE LOWER(CONCAT('%', :search, '%')))")
    List<Investor> findBySearchCriteria(@Param("search") String search, Sort sort);

    @Query("SELECT DISTINCT i.preferredDomains FROM Investor i")
    List<String> findDistinctPreferredDomains();
}