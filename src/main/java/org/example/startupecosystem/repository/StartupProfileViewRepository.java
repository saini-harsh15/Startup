package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.StartupProfileViewEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface StartupProfileViewRepository
        extends JpaRepository<StartupProfileViewEntity, Long> {

    long countByStartupId(Long startupId);

    List<StartupProfileViewEntity> findTop20ByStartupIdOrderByViewedAtDesc(Long startupId);

    Optional<StartupProfileViewEntity>
    findTopByStartupIdAndInvestorIdOrderByViewedAtDesc(Long startupId, Long investorId);

     @Query("""
        SELECT v.investorId, COUNT(v), MAX(v.viewedAt)
        FROM StartupProfileViewEntity v
        WHERE v.startupId = :startupId
        GROUP BY v.investorId
        ORDER BY MAX(v.viewedAt) DESC
    """)
    List<Object[]> findViewerAnalytics(@Param("startupId") Long startupId);


    @Query("""
SELECT COUNT(DISTINCT v.investorId)
FROM StartupProfileViewEntity v
WHERE v.startupId = :startupId
""")
    long countUniqueViewers(@Param("startupId") Long startupId);
}