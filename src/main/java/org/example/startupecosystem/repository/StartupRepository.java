package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.Startup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StartupRepository extends JpaRepository<Startup, Long> {
    // This method is used by the LoginService to find a user by their email.
    // The password comparison is then handled by the PasswordEncoder in the service.
    Optional<Startup> findByEmail(String email);
}
