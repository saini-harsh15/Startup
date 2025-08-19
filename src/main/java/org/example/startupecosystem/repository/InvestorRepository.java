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

    // Original search method (without sorting)
    @Query("SELECT i FROM Investor i WHERE " +
            "(:search IS NULL OR :search = '' OR LOWER(i.investorName) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(i.preferredDomains) LIKE LOWER(CONCAT('%', :search, '%'))) OR " +
            "(:search IS NULL OR :search = '' OR LOWER(i.investorType) LIKE LOWER(CONCAT('%', :search, '%')))")
    List<Investor> findBySearchCriteria(@Param("search") String search);

    // New overloaded method for search with sorting
    @Query("SELECT i FROM Investor i WHERE " +
            "(:search IS NULL OR :search = '' OR LOWER(i.investorName) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(i.preferredDomains) LIKE LOWER(CONCAT('%', :search, '%'))) OR " +
            "(:search IS NULL OR :search = '' OR LOWER(i.investorType) LIKE LOWER(CONCAT('%', :search, '%')))")
    List<Investor> findBySearchCriteria(@Param("search") String search, Sort sort);

    @Query("SELECT DISTINCT i.preferredDomains FROM Investor i")
    List<String> findDistinctPreferredDomains();
}