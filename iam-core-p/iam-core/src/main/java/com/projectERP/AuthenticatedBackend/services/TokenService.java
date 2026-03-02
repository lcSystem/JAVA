package com.projectERP.AuthenticatedBackend.services;

import java.time.Instant;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.stereotype.Service;

import com.projectERP.AuthenticatedBackend.models.ApplicationUser;

@Service
public class TokenService {

    @Autowired
    private JwtEncoder jwtEncoder;

    // Token expiration: 8 hours for a work day
    private static final long TOKEN_EXPIRATION_SECONDS = 8 * 60 * 60;

    public String generateJwt(Authentication auth) {

        Instant now = Instant.now();
        Instant expirationTime = now.plusSeconds(TOKEN_EXPIRATION_SECONDS);

        String scope = auth.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(" "));

        // Extract userId if principal is ApplicationUser
        JwtClaimsSet.Builder claimsBuilder = JwtClaimsSet.builder()
                .issuer("iam-core")
                .issuedAt(now)
                .expiresAt(expirationTime)
                .subject(auth.getName())
                .claim("roles", scope);

        if (auth.getPrincipal() instanceof ApplicationUser) {
            ApplicationUser user = (ApplicationUser) auth.getPrincipal();
            claimsBuilder.claim("userId", user.getUserId());
        }

        return jwtEncoder.encode(JwtEncoderParameters.from(claimsBuilder.build())).getTokenValue();
    }
}
