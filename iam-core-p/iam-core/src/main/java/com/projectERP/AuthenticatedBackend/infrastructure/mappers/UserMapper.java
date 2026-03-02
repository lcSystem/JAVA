package com.projectERP.AuthenticatedBackend.infrastructure.mappers;

import com.projectERP.AuthenticatedBackend.domain.model.User;
import com.projectERP.AuthenticatedBackend.domain.model.UserProfile;
import com.projectERP.AuthenticatedBackend.models.ApplicationUser;
import java.util.stream.Collectors;

public class UserMapper {
    public static User toDomain(ApplicationUser entity) {
        if (entity == null)
            return null;

        UserProfile profile = new UserProfile(
                entity.getFirstName(),
                entity.getLastName(),
                entity.getPhone(),
                entity.getBio(),
                entity.getProfilePicture(),
                entity.getFacebook(),
                entity.getTwitter(),
                entity.getLinkedin(),
                entity.getInstagram(),
                entity.getCountry(),
                entity.getCity(),
                entity.getPostalCode(),
                entity.getTaxId());

        return new User(
                entity.getUserId(),
                entity.getUsername(),
                entity.getPassword(),
                entity.getEmail(),
                entity.getEstado(),
                entity.getFechaCreacion(),
                entity.getOrganizacionId(),
                profile,
                entity.getAuthorities().stream()
                        .map(auth -> (com.projectERP.AuthenticatedBackend.models.Role) auth)
                        .map(RoleMapper::toDomain)
                        .collect(Collectors.toSet()));
    }

    public static ApplicationUser toEntity(User domain) {
        if (domain == null)
            return null;

        ApplicationUser entity = new ApplicationUser();
        entity.setId(domain.getId());
        entity.setUsername(domain.getUsername());
        entity.setPassword(domain.getPassword());
        entity.setEmail(domain.getEmail());
        entity.setEstado(domain.isActive());
        entity.setFechaCreacion(domain.getCreatedAt());
        entity.setOrganizacionId(domain.getOrganizationId());

        if (domain.getProfile() != null) {
            entity.setFirstName(domain.getProfile().firstName());
            entity.setLastName(domain.getProfile().lastName());
            entity.setPhone(domain.getProfile().phone());
            entity.setBio(domain.getProfile().bio());
            entity.setProfilePicture(domain.getProfile().profilePicture());
            entity.setFacebook(domain.getProfile().facebook());
            entity.setTwitter(domain.getProfile().twitter());
            entity.setLinkedin(domain.getProfile().linkedin());
            entity.setInstagram(domain.getProfile().instagram());
            entity.setCountry(domain.getProfile().country());
            entity.setCity(domain.getProfile().city());
            entity.setPostalCode(domain.getProfile().postalCode());
            entity.setTaxId(domain.getProfile().taxId());
        }

        return entity;
    }
}
