package com.clientauth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CustomerContactResponse {
    private Long id;
    private String name;
    private String phone;
    private String email;
    private String position;
    private String documentNumber;
    private LocalDate birthDate;
    private Boolean isLegalRepresentative;
}
