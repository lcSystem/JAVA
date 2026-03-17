package com.parametrizaciones.infrastructure.rest.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CatalogDto {
    private Long id;
    private String code;
    private String name;
    private String description;
    private String type;
    private boolean enabled;
}
