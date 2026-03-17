package com.parametrizaciones.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Catalog {
    private Long id;
    private String code;
    private String name;
    private String description;
    private CatalogType type;
    private boolean enabled;

    public enum CatalogType {
        STATIC, DYNAMIC, SYSTEM
    }
}
