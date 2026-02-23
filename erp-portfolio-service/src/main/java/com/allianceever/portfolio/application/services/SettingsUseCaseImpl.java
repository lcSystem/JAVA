package com.allianceever.portfolio.application.services;

import com.allianceever.portfolio.domain.model.PortfolioSettings;
import com.allianceever.portfolio.domain.ports.in.SettingsUseCase;
import com.allianceever.portfolio.domain.ports.out.ParameterClientPort;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.Arrays;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
public class SettingsUseCaseImpl implements SettingsUseCase {

    private final ParameterClientPort parameterClient;
    private final int defaultMaxFileSizeMb;
    private final String defaultAllowedExtensions;
    private final boolean defaultRequireReAuth;

    @Override
    public PortfolioSettings getSettings() {
        try {
            return parameterClient.fetchPortfolioSettings()
                    .orElseGet(this::buildDefaults);
        } catch (Exception e) {
            log.warn("Failed to fetch settings from Parameter service, using defaults: {}", e.getMessage());
            return buildDefaults();
        }
    }

    private PortfolioSettings buildDefaults() {
        List<String> extensions = Arrays.asList(defaultAllowedExtensions.split(","));
        return PortfolioSettings.builder()
                .maxFileSizeMb(defaultMaxFileSizeMb)
                .allowedExtensions(extensions)
                .requireReAuth(defaultRequireReAuth)
                .build();
    }
}
