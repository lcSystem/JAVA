package com.clientauth.controller;

import com.clientauth.dto.CustomerProfileResponse;
import com.clientauth.dto.ProfileUpdateRequest;
import com.clientauth.service.ProfileService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/client/perfil")
@RequiredArgsConstructor
public class ProfileController {

    private final ProfileService profileService;

    /**
     * Get the authenticated client's profile.
     */
    @GetMapping
    public ResponseEntity<CustomerProfileResponse> getProfile(Authentication authentication) {
        Long customerId = Long.parseLong(authentication.getName());
        return ResponseEntity.ok(profileService.getProfile(customerId));
    }

    /**
     * Update the authenticated client's profile.
     * Only non-null fields are updated. Clients cannot delete information.
     */
    @PutMapping
    public ResponseEntity<CustomerProfileResponse> updateProfile(
            Authentication authentication,
            @Valid @RequestBody ProfileUpdateRequest request) {
        Long customerId = Long.parseLong(authentication.getName());
        return ResponseEntity.ok(profileService.updateProfile(customerId, request));
    }
}
