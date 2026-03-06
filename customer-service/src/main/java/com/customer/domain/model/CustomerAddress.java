package com.customer.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CustomerAddress {
    private Long id;
    private Long customerId;
    private String street;
    private String city;
    private String state;
    private String country;
    private String postalCode;
    private AddressType addressType;
    private LocalDateTime createdAt;
}
