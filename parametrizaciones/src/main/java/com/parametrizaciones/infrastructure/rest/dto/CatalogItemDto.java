package com.parametrizaciones.infrastructure.rest.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CatalogItemDto {
    private Long id;
    private String catalogCode;
    private Long parentId;
    private Long companyId;
    private String code;
    private String name;
    private String description;
    private Integer orderIndex;
    private String path;
    private Integer level;
    private String extraData;
    private boolean enabled;

    // Audit (read-only in responses)
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;
}
