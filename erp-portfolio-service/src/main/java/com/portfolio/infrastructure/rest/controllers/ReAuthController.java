package com.portfolio.infrastructure.rest.controllers;

import com.portfolio.domain.ports.in.ReAuthUseCase;
import com.portfolio.infrastructure.rest.dto.ReAuthRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/portfolio/reauth")
@RequiredArgsConstructor
public class ReAuthController {

    private final ReAuthUseCase reAuthUseCase;

    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, Object>> reAuthenticate(@Valid @RequestBody ReAuthRequest request) {
        String token = reAuthUseCase.validateAndIssueToken(request.getUsername(), request.getPassword());
        return ResponseEntity.ok(Map.of(
                "portfolioToken", token,
                "expiresInSeconds", 300,
                "message", "Re-authentication successful. Use this token in X-Portfolio-Token header."));
    }
}
