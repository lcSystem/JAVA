package com.allianceever.creditos.infrastructure.mappers;

import com.allianceever.creditos.dto.ReferenceDTO;

public class ReferenceMapper {
    public static com.allianceever.creditos.domain.model.Reference toDomain(
            com.allianceever.creditos.model.Reference entity) {
        if (entity == null)
            return null;
        return com.allianceever.creditos.domain.model.Reference.builder()
                .id(entity.getId())
                .fullName(entity.getFullName())
                .phone(entity.getPhone())
                .relationship(entity.getRelationship())
                .type(entity.getType())
                .build();
    }

    public static com.allianceever.creditos.model.Reference toEntity(
            com.allianceever.creditos.domain.model.Reference domain) {
        if (domain == null)
            return null;
        return com.allianceever.creditos.model.Reference.builder()
                .id(domain.getId())
                .fullName(domain.getFullName())
                .phone(domain.getPhone())
                .relationship(domain.getRelationship())
                .type(domain.getType())
                .build();
    }

    public static ReferenceDTO toDTO(com.allianceever.creditos.domain.model.Reference domain) {
        if (domain == null)
            return null;
        return ReferenceDTO.builder()
                .id(domain.getId())
                .fullName(domain.getFullName())
                .phone(domain.getPhone())
                .relationship(domain.getRelationship())
                .type(domain.getType())
                .build();
    }

    public static com.allianceever.creditos.domain.model.Reference toDomain(ReferenceDTO dto) {
        if (dto == null)
            return null;
        return com.allianceever.creditos.domain.model.Reference.builder()
                .id(dto.getId())
                .fullName(dto.getFullName())
                .phone(dto.getPhone())
                .relationship(dto.getRelationship())
                .type(dto.getType())
                .build();
    }
}
