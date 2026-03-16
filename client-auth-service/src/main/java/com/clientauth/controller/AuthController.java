package com.clientauth.controller;

import com.clientauth.dto.*;
import com.clientauth.service.ClientAuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/client/auth")
@RequiredArgsConstructor
public class AuthController {

    private final ClientAuthService authService;

    /**
     * Login with cédula (document number) and password.
     * Public endpoint — no authentication required.
     */
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse response = authService.login(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Refresh the access token using a valid refresh token.
     * Public endpoint — no authentication required.
     */
    @PostMapping("/refresh")
    public ResponseEntity<LoginResponse> refresh(@Valid @RequestBody RefreshRequest request) {
        LoginResponse response = authService.refresh(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Logout — revoke all refresh tokens for the authenticated client.
     */
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(Authentication authentication) {
        Long customerId = Long.parseLong(authentication.getName());
        authService.logout(customerId);
        return ResponseEntity.noContent().build();
    }

    /**
     * Change password for the authenticated client.
     */
    @PostMapping("/change-password")
    public ResponseEntity<Void> changePassword(Authentication authentication,
            @Valid @RequestBody ChangePasswordRequest request) {
        Long customerId = Long.parseLong(authentication.getName());
        authService.changePassword(customerId, request);
        return ResponseEntity.noContent().build();
    }
}
