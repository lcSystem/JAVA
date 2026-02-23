package com.allianceever.portfolio.domain.ports.out;

import com.allianceever.portfolio.domain.model.SystemSetting;

import java.util.List;
import java.util.Optional;

public interface SettingsRepository {
    List<SystemSetting> findAll();

    Optional<SystemSetting> findByKey(String key);

    SystemSetting save(SystemSetting setting);
}
