package com.projectERP.AuthenticatedBackend.domain.model;

import java.util.Set;
import java.time.LocalDateTime;

public class User {
    private final Integer id;
    private final String username;
    private final String password;
    private final String email;
    private final boolean active;
    private final LocalDateTime createdAt;
    private final Long organizationId;
    private final UserProfile profile;
    private final Set<Role> roles;

    public User(Integer id, String username, String password, String email, boolean active,
            LocalDateTime createdAt, Long organizationId, UserProfile profile, Set<Role> roles) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.active = active;
        this.createdAt = createdAt;
        this.organizationId = organizationId;
        this.profile = profile;
        this.roles = roles;
    }

    public Integer getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getEmail() {
        return email;
    }

    public boolean isActive() {
        return active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public Long getOrganizationId() {
        return organizationId;
    }

    public UserProfile getProfile() {
        return profile;
    }

    public Set<Role> getRoles() {
        return roles;
    }
}
