package com.allianceever.portfolio.domain.exception;

public class ReAuthRequiredException extends RuntimeException {
    public ReAuthRequiredException(String message) {
        super(message);
    }
}
