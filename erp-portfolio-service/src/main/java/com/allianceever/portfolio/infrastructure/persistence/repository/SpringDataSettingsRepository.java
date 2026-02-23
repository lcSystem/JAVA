package com.allianceever.portfolio.infrastructure.persistence.repository;

import com.allianceever.portfolio.infrastructure.persistence.entity.SystemSettingEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface SpringDataSettingsRepository extends JpaRepository<SystemSettingEntity, UUID> {
    Optional<SystemSettingEntity> findByKey(String key);
}
