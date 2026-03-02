package com.creditos.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReferenceDTO {
    private Long id;
    private String fullName;
    private String phone;
    private String relationship;
    private String type; // PERSONAL, FAMILY
}
