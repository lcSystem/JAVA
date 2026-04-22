package com.reportes.infrastructure.delivery.rest;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleAllExceptions(Exception ex) {
        log.error("Unhandled Exception: ", ex);
        Map<String, String> response = new HashMap<>();

        String msg = ex.getMessage() != null ? ex.getMessage() : "Error interno del servidor";

        if (msg.contains("unavailable for data extraction") || msg.contains("Connection refused")) {
            response.put("message", "Error de conectividad: Un microservicio necesario no está corriendo. " + msg);
            response.put("error", "Service Unavailable");
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
        }

        response.put("message", msg);
        response.put("error", "Internal Server Error");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}
