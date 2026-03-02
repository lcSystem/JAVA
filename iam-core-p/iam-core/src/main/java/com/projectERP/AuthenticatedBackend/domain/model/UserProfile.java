package com.projectERP.AuthenticatedBackend.domain.model;

public record UserProfile(
        String firstName,
        String lastName,
        String phone,
        String bio,
        String profilePicture,
        String facebook,
        String twitter,
        String linkedin,
        String instagram,
        String country,
        String city,
        String postalCode,
        String taxId) {
}
