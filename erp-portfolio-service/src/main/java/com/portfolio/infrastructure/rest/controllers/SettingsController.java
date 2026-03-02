package com.portfolio.infrastructure.rest.controllers;

import com.portfolio.domain.model.PortfolioSettings;
import com.portfolio.domain.model.SystemSetting;
import com.portfolio.domain.ports.in.SettingsUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/portfolio/settings")
@RequiredArgsConstructor
public class SettingsController {

    private final SettingsUseCase settingsUseCase;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('PORTFOLIO_READ')")
    public ResponseEntity<PortfolioSettings> getPortfolioSettings() {
        return ResponseEntity.ok(settingsUseCase.getSettings());
    }

    @GetMapping("/raw")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<SystemSetting>> getAllRawSettings() {
        return ResponseEntity.ok(settingsUseCase.getAllSettings());
    }

    @GetMapping("/{key}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<SystemSetting> getSetting(@PathVariable String key) {
        return ResponseEntity.ok(settingsUseCase.getSetting(key));
    }

    @PutMapping("/{key}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<SystemSetting> updateSetting(
            @PathVariable String key,
            @RequestBody Map<String, String> request) {
        String value = request.get("value");
        return ResponseEntity.ok(settingsUseCase.updateSetting(key, value));
    }
}
