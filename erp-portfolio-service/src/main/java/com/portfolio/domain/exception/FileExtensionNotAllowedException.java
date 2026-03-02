package com.portfolio.domain.exception;

public class FileExtensionNotAllowedException extends RuntimeException {
    public FileExtensionNotAllowedException(String message) {
        super(message);
    }
}
