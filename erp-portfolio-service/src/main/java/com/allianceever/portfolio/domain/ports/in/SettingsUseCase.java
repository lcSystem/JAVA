package com.allianceever.portfolio.domain.ports.in;

import com.allianceever.portfolio.domain.model.PortfolioSettings;
import com.allianceever.portfolio.domain.model.SystemSetting;

import java.util.List;

public interface SettingsUseCase {
    PortfolioSettings getSettings();

    List<SystemSetting> getAllSettings();

    SystemSetting getSetting(String key);

    SystemSetting updateSetting(String key, String value);
}
