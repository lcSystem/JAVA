package com.allianceever.projectERP.AuthenticatedBackend.infrastructure.adapters;

import com.allianceever.projectERP.AuthenticatedBackend.domain.model.User;
import com.allianceever.projectERP.AuthenticatedBackend.domain.ports.out.SecurityPort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class SecurityAdapter implements SecurityPort {

    private final PasswordEncoder passwordEncoder;

    public SecurityAdapter(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public String encryptPassword(String rawPassword) {
        return passwordEncoder.encode(rawPassword);
    }

    @Override
    public boolean verifyPassword(String rawPassword, String encryptedPassword) {
        return passwordEncoder.matches(rawPassword, encryptedPassword);
    }

    @Override
    public String generateToken(User user) {
        return null;
    }
}
