package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.Startup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StartupRepository extends JpaRepository<Startup, Long> {

    Optional<Startup> findById(Long id);

    Optional<Startup> findByEmail(String email);

    // Custom query method for filtering startups
    @Query("SELECT s FROM Startup s WHERE " +
            "(:search IS NULL OR :search = '' OR LOWER(s.name) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(s.industry) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
            "(:industry IS NULL OR :industry = '' OR s.industry = :industry)")
    List<Startup> findBySearchCriteria(@Param("search") String search, @Param("industry") String industry);

    @Query("SELECT DISTINCT s.industry FROM Startup s")
    List<String> findDistinctIndustries();
}