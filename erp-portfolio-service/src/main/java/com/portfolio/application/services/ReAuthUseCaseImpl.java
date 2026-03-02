package com.portfolio.application.services;

import com.portfolio.domain.exception.UnauthorizedAccessException;
import com.portfolio.domain.ports.in.ReAuthUseCase;
import com.portfolio.domain.ports.out.IamClientPort;
import lombok.extern.slf4j.Slf4j;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Re-authentication use case.
 * Validates password against IAM, issues a short-lived HMAC token (5 min TTL).
 * The token is a signed timestamp that proves recent re-authentication.
 */
@Slf4j
public class ReAuthUseCaseImpl implements ReAuthUseCase {

    private final IamClientPort iamClient;
    private final String hmacSecret;
    private static final long TOKEN_TTL_SECONDS = 300; // 5 minutes

    // In-memory blacklist for revoked tokens (in production, use Redis)
    private final ConcurrentHashMap<String, Instant> issuedTokens = new ConcurrentHashMap<>();

    public ReAuthUseCaseImpl(IamClientPort iamClient, String hmacSecret) {
        this.iamClient = iamClient;
        this.hmacSecret = hmacSecret;
    }

    @Override
    public String validateAndIssueToken(String username, String password) {
        boolean valid = iamClient.validatePassword(username, password);
        if (!valid) {
            throw new UnauthorizedAccessException("Invalid credentials for re-authentication");
        }

        // Generate short-lived token: username:timestamp:hmac
        long now = Instant.now().getEpochSecond();
        String payload = username + ":" + now;
        String signature = hmacSign(payload);
        String token = Base64.getUrlEncoder().encodeToString(
                (payload + ":" + signature).getBytes(StandardCharsets.UTF_8));

        issuedTokens.put(token, Instant.now());
        log.info("Issued re-auth token for user {} (TTL: {}s)", username, TOKEN_TTL_SECONDS);
        return token;
    }

    @Override
    public boolean isTokenValid(String token) {
        try {
            String decoded = new String(Base64.getUrlDecoder().decode(token), StandardCharsets.UTF_8);
            String[] parts = decoded.split(":");
            if (parts.length != 3)
                return false;

            String username = parts[0];
            long timestamp = Long.parseLong(parts[1]);
            String signature = parts[2];

            // Verify signature
            String payload = username + ":" + timestamp;
            if (!hmacSign(payload).equals(signature))
                return false;

            // Verify TTL
            long elapsed = Instant.now().getEpochSecond() - timestamp;
            return elapsed <= TOKEN_TTL_SECONDS;
        } catch (Exception e) {
            log.warn("Invalid re-auth token: {}", e.getMessage());
            return false;
        }
    }

    private String hmacSign(String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec keySpec = new SecretKeySpec(
                    hmacSecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            mac.init(keySpec);
            byte[] rawHmac = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(rawHmac);
        } catch (Exception e) {
            throw new RuntimeException("Failed to compute HMAC", e);
        }
    }
}
