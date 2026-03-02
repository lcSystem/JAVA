package com.portfolio.infrastructure.security;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.stream.Collectors;

public class CustomAuthoritiesConverter implements Converter<Jwt, Collection<GrantedAuthority>> {

    @Override
    public Collection<GrantedAuthority> convert(Jwt jwt) {
        Collection<GrantedAuthority> authorities = new HashSet<>();

        // Handle roles – add ROLE_ prefix if missing
        extractAuthorities(jwt, "roles").stream()
                .map(auth -> {
                    String authority = auth.getAuthority();
                    if (!authority.startsWith("ROLE_")) {
                        return new SimpleGrantedAuthority("ROLE_" + authority);
                    }
                    return auth;
                })
                .forEach(authorities::add);

        // Handle permissions – keep as raw authorities
        extractAuthorities(jwt, "permissions").forEach(authorities::add);

        return authorities;
    }

    private Collection<GrantedAuthority> extractAuthorities(Jwt jwt, String claimName) {
        Object claim = jwt.getClaim(claimName);
        if (claim == null) {
            return Collections.emptyList();
        }

        if (claim instanceof String claimStr) {
            if (claimStr.isEmpty()) {
                return Collections.emptyList();
            }
            return Arrays.stream(claimStr.split(" "))
                    .map(SimpleGrantedAuthority::new)
                    .collect(Collectors.toList());
        } else if (claim instanceof Collection<?> claimCol) {
            return claimCol.stream()
                    .map(Object::toString)
                    .map(SimpleGrantedAuthority::new)
                    .collect(Collectors.toList());
        }

        return Collections.emptyList();
    }
}
