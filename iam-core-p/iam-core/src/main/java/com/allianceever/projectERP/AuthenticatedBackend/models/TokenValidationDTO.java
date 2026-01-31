package com.allianceever.projectERP.AuthenticatedBackend.models;

public class TokenValidationDTO {
    private boolean valid;
    private String message;
    private String username;

    public TokenValidationDTO(boolean valid, String message, String username) {
        this.valid = valid;
        this.message = message;
        this.username = username;
    }

    public TokenValidationDTO(boolean valid, String message) {
        this.valid = valid;
        this.message = message;
        this.username = null;
    }

    public boolean isValid() {
        return valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
