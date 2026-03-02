package com.creditos.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreditReferenceDTO {
    private Long id;
    private String relationship;
    private String fullName;
    private String phone;
    private String referenceType; // 'FAMILY' or 'PERSONAL'
}
