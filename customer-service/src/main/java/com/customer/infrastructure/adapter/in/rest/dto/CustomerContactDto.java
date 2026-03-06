package com.customer.infrastructure.adapter.in.rest.dto;

import lombok.Data;

@Data
public class CustomerContactDto {
    private Long id;
    private String name;
    private String position;
    private String email;
    private String phone;
}
