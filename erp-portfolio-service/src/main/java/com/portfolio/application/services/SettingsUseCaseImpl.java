package com.portfolio.application.services;

import com.portfolio.domain.exception.ResourceNotFoundException;
import com.portfolio.domain.model.PortfolioSettings;
import com.portfolio.domain.model.SystemSetting;
import com.portfolio.domain.ports.in.SettingsUseCase;
import com.portfolio.domain.ports.out.ParameterClientPort;
import com.portfolio.domain.ports.out.SettingsRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
public class SettingsUseCaseImpl implements SettingsUseCase {

        private final SettingsRepository settingsRepository;
        private final ParameterClientPort parameterClient;
        private final int defaultMaxFileSizeMb;
        private final String defaultAllowedExtensions;
        private final boolean defaultRequireReAuth;

        @Override
        public PortfolioSettings getSettings() {
                // 1. Try to fetch from central service
                Optional<PortfolioSettings> centralSettings = parameterClient.fetchPortfolioSettings();

                // 2. Fetch local settings for potential overrides/fallback
                List<SystemSetting> localSettings = settingsRepository.findAll();

                if (centralSettings.isPresent()) {
                        PortfolioSettings cs = centralSettings.get();
                        // If local settings exist, they could act as overrides.
                        // For now, let's prioritize central ones if they exist.
                        return cs;
                }

                if (!localSettings.isEmpty()) {
                        int maxSize = Integer
                                        .parseInt(findValue(localSettings, "max_file_size_mb",
                                                        String.valueOf(defaultMaxFileSizeMb)));
                        String extensions = findValue(localSettings, "allowed_extensions", defaultAllowedExtensions);
                        boolean reAuth = Boolean
                                        .parseBoolean(findValue(localSettings, "require_reauth",
                                                        String.valueOf(defaultRequireReAuth)));

                        return PortfolioSettings.builder()
                                        .maxFileSizeMb(maxSize)
                                        .allowedExtensions(Arrays.stream(extensions.split(","))
                                                        .map(String::trim)
                                                        .filter(s -> !s.isEmpty())
                                                        .collect(Collectors.toList()))
                                        .requireReAuth(reAuth)
                                        .build();
                }

                return buildDefaults();
        }

        @Override
        public List<SystemSetting> getAllSettings() {
                return settingsRepository.findAll();
        }

        @Override
        public SystemSetting getSetting(String key) {
                return settingsRepository.findByKey(key)
                                .orElseThrow(() -> new ResourceNotFoundException("Setting not found: " + key));
        }

        @Override
        public SystemSetting updateSetting(String key, String value) {
                SystemSetting setting = getSetting(key);
                setting.setValue(value);
                SystemSetting saved = settingsRepository.save(setting);
                log.info("Updated system setting: {} = {}", key, value);
                return saved;
        }

        private String findValue(List<SystemSetting> settings, String key, String defaultValue) {
                return settings.stream()
                                .filter(s -> s.getKey().equals(key))
                                .map(SystemSetting::getValue)
                                .findFirst()
                                .orElse(defaultValue);
        }

        private PortfolioSettings buildDefaults() {
                List<String> extensions = Arrays.stream(defaultAllowedExtensions.split(","))
                                .map(String::trim)
                                .filter(s -> !s.isEmpty())
                                .collect(Collectors.toList());
                return PortfolioSettings.builder()
                                .maxFileSizeMb(defaultMaxFileSizeMb)
                                .allowedExtensions(extensions)
                                .requireReAuth(defaultRequireReAuth)
                                .build();
        }
}
