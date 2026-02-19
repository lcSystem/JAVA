package com.allianceever.projectERP.AuthenticatedBackend.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.server.authorization.token.JwtEncodingContext;
import org.springframework.security.oauth2.server.authorization.token.OAuth2TokenCustomizer;
import org.springframework.security.oauth2.server.authorization.OAuth2TokenType;

import java.util.Set;
import java.util.stream.Collectors;

@Configuration
public class CustomJwtCustomizer {

    @Bean
    public OAuth2TokenCustomizer<JwtEncodingContext> jwtTokenCustomizer() {
        return (context) -> {
            if (OAuth2TokenType.ACCESS_TOKEN.equals(context.getTokenType())) {
                context.getClaims().claims((claims) -> {
                    Set<String> roles = context.getPrincipal().getAuthorities().stream()
                            .filter(a -> a.getAuthority().startsWith("ROLE_"))
                            .map(GrantedAuthority::getAuthority)
                            .collect(Collectors.toSet());

                    Set<String> permissions = context.getPrincipal().getAuthorities().stream()
                            .filter(a -> !a.getAuthority().startsWith("ROLE_"))
                            .map(GrantedAuthority::getAuthority)
                            .collect(Collectors.toSet());

                    claims.put("roles", roles);
                    claims.put("permissions", permissions);

                    // User also wants "username"
                    claims.put("username", context.getPrincipal().getName());

                    // sub is usually user_id, which we should get from principal
                    // Assuming name is the username or ID. User requested "sub": "user_id"
                    // If ApplicationUser is used, we might need to cast
                });
            }
        };
    }
}
