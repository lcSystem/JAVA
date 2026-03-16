package com.clientauth.security;

import com.clientauth.service.JwtService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * JWT authentication filter for client requests.
 * Extracts the JWT from the Authorization header and sets the
 * SecurityContext with the client's id and granted authorities.
 */
@Component
@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtService jwtService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);
        try {
            if (jwtService.isTokenValid(token)) {
                var claims = jwtService.extractClaims(token);
                String customerId = claims.getSubject();

                // Extract scopes as authorities
                @SuppressWarnings("unchecked")
                List<String> scopes = claims.get("scope", List.class);
                List<SimpleGrantedAuthority> authorities = scopes != null
                        ? scopes.stream()
                                .map(SimpleGrantedAuthority::new)
                                .collect(Collectors.toList())
                        : List.of();

                // Add role as authority
                String role = claims.get("role", String.class);
                if (role != null) {
                    authorities = new java.util.ArrayList<>(authorities);
                    authorities.add(new SimpleGrantedAuthority("ROLE_" + role));
                }

                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        customerId, null, authorities);

                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        } catch (Exception e) {
            // Token invalid — continue without authentication
            SecurityContextHolder.clearContext();
        }

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getServletPath();
        // Don't filter public endpoints
        return path.startsWith("/api/client/auth/login")
                || path.startsWith("/api/client/auth/refresh")
                || path.startsWith("/api/config-creditos")
                || path.startsWith("/actuator");
    }
}
