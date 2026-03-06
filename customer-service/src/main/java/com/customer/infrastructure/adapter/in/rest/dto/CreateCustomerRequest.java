package com.customer.infrastructure.adapter.in.rest.dto;

import com.customer.domain.model.CustomerType;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class CreateCustomerRequest {
    @NotNull(message = "Customer type is required")
    private CustomerType type;

    @NotBlank(message = "Name is required")
    private String name;

    @NotBlank(message = "Document number is required")
    private String documentNumber;

    @Email(message = "Invalid email format")
    private String email;

    private String phone;

    @Valid
    private List<CustomerAddressDto> addresses;

    @Valid
    private List<CustomerContactDto> contacts;
}
