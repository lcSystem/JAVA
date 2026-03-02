package com.portfolio.domain.exception;

public class ReAuthRequiredException extends RuntimeException {
    public ReAuthRequiredException(String message) {
        super(message);
    }
}
