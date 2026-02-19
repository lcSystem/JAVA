package com.allianceever.projectERP.AuthenticatedBackend.application.services;

import com.allianceever.projectERP.AuthenticatedBackend.domain.model.User;
import com.allianceever.projectERP.AuthenticatedBackend.domain.model.UserProfile;
import com.allianceever.projectERP.AuthenticatedBackend.domain.ports.in.ManageUserUseCase;
import com.allianceever.projectERP.AuthenticatedBackend.domain.ports.out.UserRepositoryPort;
import com.allianceever.projectERP.AuthenticatedBackend.domain.ports.out.SecurityPort;

public class ManageUserUseCaseImpl implements ManageUserUseCase {

    private final UserRepositoryPort userRepositoryPort;
    private final SecurityPort securityPort;

    public ManageUserUseCaseImpl(UserRepositoryPort userRepositoryPort, SecurityPort securityPort) {
        this.userRepositoryPort = userRepositoryPort;
        this.securityPort = securityPort;
    }

    @Override
    public User getUserById(Integer id) {
        return userRepositoryPort.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Override
    public User getUserByUsername(String username) {
        return userRepositoryPort.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Override
    public User updateUserProfile(Integer userId, UserProfile profile) {
        User user = getUserById(userId);
        User updatedUser = new User(
                user.getId(),
                user.getUsername(),
                user.getPassword(),
                user.getEmail(),
                user.isActive(),
                user.getCreatedAt(),
                user.getOrganizationId(),
                profile,
                user.getRoles());
        return userRepositoryPort.save(updatedUser);
    }

    @Override
    public void changePassword(Integer userId, String oldPassword, String newPassword) {
        User user = getUserById(userId);
        if (!securityPort.verifyPassword(oldPassword, user.getPassword())) {
            throw new RuntimeException("Invalid old password");
        }
        String encryptedPassword = securityPort.encryptPassword(newPassword);
        User updatedUser = new User(
                user.getId(),
                user.getUsername(),
                encryptedPassword,
                user.getEmail(),
                user.isActive(),
                user.getCreatedAt(),
                user.getOrganizationId(),
                user.getProfile(),
                user.getRoles());
        userRepositoryPort.save(updatedUser);
    }
}
