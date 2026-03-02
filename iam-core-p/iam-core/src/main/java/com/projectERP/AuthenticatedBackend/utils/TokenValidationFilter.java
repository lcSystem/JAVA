package com.projectERP.AuthenticatedBackend.utils;

import com.projectERP.AuthenticatedBackend.repository.TokenBlacklistRepository;
import com.projectERP.AuthenticatedBackend.services.UserSessionService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class TokenValidationFilter extends OncePerRequestFilter {

    private final TokenBlacklistRepository blacklistRepository;
    private final UserSessionService sessionService;

    @Autowired
    public TokenValidationFilter(TokenBlacklistRepository blacklistRepository, UserSessionService sessionService) {
        this.blacklistRepository = blacklistRepository;
        this.sessionService = sessionService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String token = extractToken(request);

        if (token != null) {
            String tokenHash = sessionService.hashToken(token);
            if (blacklistRepository.existsByToken(tokenHash)) {
                // Token is revoked or invalid; reject the request
                System.out.println("Token not authorized. Token hash in BlackList!");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
        }

        filterChain.doFilter(request, response);
    }

    private String extractToken(HttpServletRequest request) {
        // Get the "Authorization" header from the request
        String authorizationHeader = request.getHeader("Authorization");

        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            // Extract the token part (excluding "Bearer ")
            return authorizationHeader.substring(7);
        }

        // If the header is missing or not in the expected format, return null
        return null;
    }
}
