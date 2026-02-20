package com.allianceever.parametrizaciones.infrastructure.persistence.mappers;

import com.allianceever.parametrizaciones.domain.model.Parameter;
import com.allianceever.parametrizaciones.domain.model.ParameterCategory;
import com.allianceever.parametrizaciones.infrastructure.persistence.entities.ParameterCategoryJpaEntity;
import com.allianceever.parametrizaciones.infrastructure.persistence.entities.ParameterJpaEntity;
import org.springframework.stereotype.Component;

@Component
public class ParameterMapper {

    public Parameter toDomain(ParameterJpaEntity entity) {
        if (entity == null)
            return null;
        return Parameter.builder()
                .id(entity.getId())
                .category(toDomain(entity.getCategory()))
                .serviceName(entity.getServiceName())
                .name(entity.getName())
                .key(entity.getKey())
                .value(entity.getValue())
                .type(entity.getType())
                .version(entity.getVersion())
                .enabled(entity.isEnabled())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .createdBy(entity.getCreatedBy())
                .updatedBy(entity.getUpdatedBy())
                .build();
    }

    public ParameterCategory toDomain(ParameterCategoryJpaEntity entity) {
        if (entity == null)
            return null;
        return ParameterCategory.builder()
                .id(entity.getId())
                .name(entity.getName())
                .description(entity.getDescription())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .createdBy(entity.getCreatedBy())
                .build();
    }

    public ParameterJpaEntity toJpaEntity(Parameter domain) {
        if (domain == null)
            return null;
        return ParameterJpaEntity.builder()
                .id(domain.getId())
                .category(toJpaEntity(domain.getCategory()))
                .serviceName(domain.getServiceName())
                .name(domain.getName())
                .key(domain.getKey())
                .value(domain.getValue())
                .type(domain.getType())
                .version(domain.getVersion())
                .enabled(domain.isEnabled())
                .createdBy(domain.getCreatedBy())
                .updatedBy(domain.getUpdatedBy())
                .build();
    }

    public ParameterCategoryJpaEntity toJpaEntity(ParameterCategory domain) {
        if (domain == null)
            return null;
        return ParameterCategoryJpaEntity.builder()
                .id(domain.getId())
                .name(domain.getName())
                .description(domain.getDescription())
                .createdBy(domain.getCreatedBy())
                .build();
    }
}
