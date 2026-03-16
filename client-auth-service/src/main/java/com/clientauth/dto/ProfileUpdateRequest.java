package com.clientauth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.util.List;

/**
 * Profile update request. Clients can only edit, not delete info.
 * All fields are optional — only non-null fields are updated.
 */
@Data
public class ProfileUpdateRequest {

    @Size(min = 2, max = 150, message = "El nombre debe tener entre 2 y 150 caracteres")
    private String name;

    @Email(message = "El email debe ser válido")
    private String email;

    @Size(min = 7, max = 50, message = "El teléfono debe tener entre 7 y 50 caracteres")
    private String phone;

    private List<CustomerAddressResponse> addresses;
    private List<CustomerContactResponse> contacts;
}
