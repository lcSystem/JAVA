package com.allianceever.projectERP.AuthenticatedBackend.domain.ports.in;

import com.allianceever.projectERP.AuthenticatedBackend.domain.model.User;
import com.allianceever.projectERP.AuthenticatedBackend.domain.model.UserProfile;

public interface ManageUserUseCase {
    User getUserById(Integer id);
    User getUserByUsername(String username);
    User updateUserProfile(Integer userId, UserProfile profile);
    void changePassword(Integer userId, String oldPassword, String newPassword);
}
