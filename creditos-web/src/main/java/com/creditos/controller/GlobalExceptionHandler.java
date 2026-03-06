package com.creditos.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleAllExceptions(Exception ex) {
        ex.printStackTrace();
        String message = ex.getMessage();
        if (message == null || message.isBlank()) {
            message = ex.getClass().getName();
        }
        Throwable root = ex;
        while (root.getCause() != null) {
            root = root.getCause();
        }
        String rootMessage = root.getMessage();
        if (rootMessage == null) {
            rootMessage = root.getClass().getName();
        }
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of(
                        "error", message,
                        "rootCause", rootMessage));
    }
}
