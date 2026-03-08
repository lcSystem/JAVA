package com.customer.infrastructure.adapter.in.rest.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.Data;

@Data
public class CustomerContactDto {
    private Long id;
    private String name;
    private String position;
    private String email;
    private String phone;
    private String documentNumber;
    private LocalDate birthDate;
    private Boolean isLegalRepresentative;
    private LocalDateTime createdAt;
}
