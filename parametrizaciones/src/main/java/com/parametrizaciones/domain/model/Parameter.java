package com.parametrizaciones.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Parameter {
    private Long id;
    private ParameterCategory category;
    private String serviceName;
    private String name;
    private String key;
    private String value;
    private String type;
    private Integer version;
    private boolean enabled;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String createdBy;
    private String updatedBy;
}
