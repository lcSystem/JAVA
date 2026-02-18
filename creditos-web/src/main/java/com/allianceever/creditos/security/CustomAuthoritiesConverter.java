package com.allianceever.creditos.security;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class CustomAuthoritiesConverter implements Converter<Jwt, Collection<GrantedAuthority>> {

    @Override
    public Collection<GrantedAuthority> convert(Jwt jwt) {
        List<String> roles = jwt.getClaimAsStringList("roles");
        List<String> permissions = jwt.getClaimAsStringList("permissions");

        if (roles == null)
            roles = Collections.emptyList();
        if (permissions == null)
            permissions = Collections.emptyList();

        return Stream.concat(
                roles.stream().map(SimpleGrantedAuthority::new),
                permissions.stream().map(SimpleGrantedAuthority::new)).collect(Collectors.toSet());
    }
}
