package com.allianceever.creditos.infrastructure.mappers;

import com.allianceever.creditos.domain.model.CreditRequest;
import com.allianceever.creditos.dto.CreditRequestDTO;

public class CreditRequestMapper {
    public static CreditRequest toDomain(com.allianceever.creditos.model.CreditRequest entity) {
        if (entity == null)
            return null;
        return new CreditRequest(
                entity.getId(),
                entity.getApplicant().getUserId(),
                CreditTypeMapper.toDomain(entity.getCreditType()),
                entity.getAmount(),
                entity.getTermMonths(),
                entity.getPurpose(),
                entity.getStatus(),
                entity.getScoringResult(),
                entity.getScoringRecommendation(),
                entity.getCreatedAt());
    }

    public static com.allianceever.creditos.model.CreditRequest toEntity(CreditRequest domain) {
        if (domain == null)
            return null;
        com.allianceever.creditos.model.CreditRequest entity = new com.allianceever.creditos.model.CreditRequest();
        entity.setId(domain.getId());
        entity.setAmount(domain.getAmount());
        entity.setTermMonths(domain.getTermMonths());
        entity.setPurpose(domain.getPurpose());
        entity.setStatus(domain.getStatus());
        entity.setScoringResult(domain.getScoringResult());
        entity.setScoringRecommendation(domain.getScoringRecommendation());
        return entity;
    }

    public static CreditRequestDTO toDTO(CreditRequest domain) {
        if (domain == null)
            return null;
        return CreditRequestDTO.builder()
                .id(domain.getId())
                .applicantUserId(domain.getApplicantUserId())
                .creditTypeId(domain.getCreditType().getId())
                .amount(domain.getAmount())
                .termMonths(domain.getTermMonths())
                .purpose(domain.getPurpose())
                .status(domain.getStatus())
                .scoringResult(domain.getScoringResult())
                .build();
    }
}
