package com.allianceever.portfolio.infrastructure.rest.controllers;

import com.allianceever.portfolio.domain.model.PortfolioSettings;
import com.allianceever.portfolio.domain.ports.in.SettingsUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/portfolio/settings")
@RequiredArgsConstructor
public class SettingsController {

    private final SettingsUseCase settingsUseCase;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
    public ResponseEntity<PortfolioSettings> getSettings() {
        return ResponseEntity.ok(settingsUseCase.getSettings());
    }
}
