package com.clientauth.service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * JWT token generation and validation service for client authentication.
 * Uses a separate signing key from the admin auth system.
 */
@Service
public class JwtService {

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.expiration-ms:3600000}")
    private long jwtExpirationMs; // 1 hour default

    @Value("${jwt.refresh-expiration-ms:86400000}")
    private long refreshExpirationMs; // 24 hours default

    @Value("${jwt.issuer:client-auth}")
    private String issuer;

    /**
     * Generate an access token for a client.
     */
    public String generateToken(Long customerId, String documentNumber, String name) {
        return Jwts.builder()
                .issuer(issuer)
                .subject(customerId.toString())
                .claim("cedula", documentNumber)
                .claim("name", name)
                .claim("roles", List.of("CLIENT"))
                .claim("permissions", List.of(
                        "CREDIT_READ",
                        "CREDIT_SIM_CREATE",
                        "CREDIT_CREATE",
                        "PROFILE_READ",
                        "PROFILE_UPDATE"))
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + jwtExpirationMs))
                .signWith(getSigningKey())
                .compact();
    }

    /**
     * Extract all claims from a token.
     */
    public Claims extractClaims(String token) {
        return Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * Validate token and return true if valid.
     */
    public boolean isTokenValid(String token) {
        try {
            Claims claims = extractClaims(token);
            return !claims.getExpiration().before(new Date());
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Extract customer ID from token.
     */
    public Long extractCustomerId(String token) {
        return Long.parseLong(extractClaims(token).getSubject());
    }

    /**
     * Extract document number (cédula) from token.
     */
    public String extractCedula(String token) {
        return extractClaims(token).get("cedula", String.class);
    }

    /**
     * Get token expiration in seconds.
     */
    public long getExpirationSeconds() {
        return jwtExpirationMs / 1000;
    }

    /**
     * Get refresh token expiration in milliseconds.
     */
    public long getRefreshExpirationMs() {
        return refreshExpirationMs;
    }

    private SecretKey getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(jwtSecret);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
