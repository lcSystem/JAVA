package com.clientauth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {

    @NotBlank(message = "El número de cédula es requerido")
    private String cedula;

    @NotBlank(message = "La contraseña es requerida")
    private String password;

    private String deviceInfo;
}
