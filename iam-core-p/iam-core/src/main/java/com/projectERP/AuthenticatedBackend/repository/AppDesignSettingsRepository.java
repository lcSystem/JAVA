package com.projectERP.AuthenticatedBackend.repository;

import com.projectERP.AuthenticatedBackend.models.AppDesignSettings;
import com.projectERP.AuthenticatedBackend.models.ApplicationUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AppDesignSettingsRepository extends JpaRepository<AppDesignSettings, Long> {
    Optional<AppDesignSettings> findByUser(ApplicationUser user);
}
