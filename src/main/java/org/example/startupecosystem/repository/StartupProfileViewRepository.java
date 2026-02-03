package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.StartupProfileViewEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StartupProfileViewRepository
        extends JpaRepository<StartupProfileViewEntity, Long> {

    boolean existsByStartupIdAndInvestorId(Long startupId, Long investorId);

    long countByStartupId(Long startupId);
}
