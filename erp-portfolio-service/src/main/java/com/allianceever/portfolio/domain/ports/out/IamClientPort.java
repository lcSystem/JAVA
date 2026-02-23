package com.allianceever.portfolio.domain.ports.out;

/**
 * Port for validating user credentials against IAM service.
 * Used for re-authentication before portfolio access.
 */
public interface IamClientPort {

    /**
     * Validates a user's password against the IAM service.
     *
     * @param username the username
     * @param password the raw password
     * @return true if the credentials are valid
     */
    boolean validatePassword(String username, String password);
}
