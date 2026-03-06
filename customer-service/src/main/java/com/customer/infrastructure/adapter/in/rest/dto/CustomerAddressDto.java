package com.customer.infrastructure.adapter.in.rest.dto;

import com.customer.domain.model.AddressType;
import lombok.Data;

@Data
public class CustomerAddressDto {
    private Long id;
    private String street;
    private String city;
    private String state;
    private String country;
    private String postalCode;
    private AddressType type;
}
