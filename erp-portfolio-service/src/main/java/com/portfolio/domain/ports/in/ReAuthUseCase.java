package com.portfolio.domain.ports.in;

public interface ReAuthUseCase {

    /**
     * Validates the user's password against IAM and returns a short-lived
     * portfolio access token (5 min TTL).
     *
     * @param username the username
     * @param password the raw password to validate
     * @return short-lived JWT token for portfolio access
     */
    String validateAndIssueToken(String username, String password);

    /**
     * Validates a short-lived portfolio access token.
     *
     * @param token the portfolio access token
     * @return true if the token is valid and not expired
     */
    boolean isTokenValid(String token);
}
