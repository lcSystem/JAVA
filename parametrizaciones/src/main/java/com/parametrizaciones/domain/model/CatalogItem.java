package com.parametrizaciones.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CatalogItem {
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
    private Map<String, Object> extraData;
    private boolean enabled;
    private boolean deleted;

    // Audit
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;
}
