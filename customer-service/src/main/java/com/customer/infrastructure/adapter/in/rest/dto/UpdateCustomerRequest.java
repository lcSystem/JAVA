package com.customer.infrastructure.adapter.in.rest.dto;

import com.customer.domain.model.CustomerStatus;
import com.customer.domain.model.CustomerType;
import jakarta.validation.Valid;
import lombok.Data;

import java.util.List;

@Data
public class UpdateCustomerRequest {
    private Long id;
    private CustomerType type;
    private String name;
    private String documentNumber;
    private String email;
    private String phone;
    private CustomerStatus status;

    @Valid
    private List<CustomerAddressDto> addresses;

    @Valid
    private List<CustomerContactDto> contacts;
}
