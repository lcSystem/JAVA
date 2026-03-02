package com.projectERP.AuthenticatedBackend.domain.ports.out;

import com.projectERP.AuthenticatedBackend.domain.model.User;

public interface SecurityPort {
    String encryptPassword(String rawPassword);
    boolean verifyPassword(String rawPassword, String encryptedPassword);
    String generateToken(User user);
}
