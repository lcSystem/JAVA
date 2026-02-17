package com.allianceever.projectERP.AuthenticatedBackend.controllers;

import com.allianceever.projectERP.AuthenticatedBackend.models.AppDesignSettingsDTO;
import com.allianceever.projectERP.AuthenticatedBackend.services.AppDesignSettingsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/design")
public class AppDesignSettingsController {

    @Autowired
    private AppDesignSettingsService designService;

    @GetMapping
    public ResponseEntity<AppDesignSettingsDTO> getDesignSettings(@AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        return ResponseEntity.ok(designService.getDesignSettings(username));
    }

    @PostMapping
    public ResponseEntity<AppDesignSettingsDTO> updateDesignSettings(
            @AuthenticationPrincipal Jwt jwt,
            @RequestBody AppDesignSettingsDTO dto) {
        String username = jwt.getClaimAsString("sub");
        return ResponseEntity.ok(designService.updateDesignSettings(username, dto));
    }

    @PostMapping("/logo")
    public ResponseEntity<String> uploadLogo(
            @AuthenticationPrincipal Jwt jwt,
            @RequestParam("file") MultipartFile file) {
        String username = jwt.getClaimAsString("sub");
        String logoUrl = designService.uploadLogo(username, file);
        return ResponseEntity.ok(logoUrl);
    }

    @PostMapping("/favicon")
    public ResponseEntity<String> uploadFavicon(
            @AuthenticationPrincipal Jwt jwt,
            @RequestParam("file") MultipartFile file) {
        String username = jwt.getClaimAsString("sub");
        String faviconUrl = designService.uploadFavicon(username, file);
        return ResponseEntity.ok(faviconUrl);
    }
}
