package com.reportes.domain.exception;

public class IllegalSqlOperationException extends RuntimeException {
    public IllegalSqlOperationException(String message) {
        super(message);
    }
}
