package com.allianceever.projectERP.AuthenticatedBackend.repository;

import com.allianceever.projectERP.AuthenticatedBackend.models.AppDesignSettings;
import com.allianceever.projectERP.AuthenticatedBackend.models.ApplicationUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AppDesignSettingsRepository extends JpaRepository<AppDesignSettings, Long> {
    Optional<AppDesignSettings> findByUser(ApplicationUser user);
}
