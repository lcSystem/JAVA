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
                entity.getCoDebtorName(),
                entity.getCoDebtorId(),
                entity.getRepresentativeName(),
                entity.getRepresentativeId(),
                entity.getDebtorAdditionalInfo(),
                CoDebtorMapper.toDomain(entity.getCoDebtorProfile()),
                CoDebtorMapper.toDomain(entity.getRepresentativeProfile()),
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
        entity.setCoDebtorName(domain.getCoDebtorName());
        entity.setCoDebtorId(domain.getCoDebtorId());
        entity.setRepresentativeName(domain.getRepresentativeName());
        entity.setRepresentativeId(domain.getRepresentativeId());
        entity.setDebtorAdditionalInfo(domain.getDebtorAdditionalInfo());
        entity.setCoDebtorProfile(CoDebtorMapper.toEntity(domain.getCoDebtorProfile()));
        entity.setRepresentativeProfile(CoDebtorMapper.toEntity(domain.getRepresentativeProfile()));
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
                .coDebtorName(domain.getCoDebtorName())
                .coDebtorId(domain.getCoDebtorId())
                .representativeName(domain.getRepresentativeName())
                .representativeId(domain.getRepresentativeId())
                .debtorAdditionalInfo(domain.getDebtorAdditionalInfo())
                .coDebtorProfile(CoDebtorMapper.toDTO(domain.getCoDebtorProfile()))
                .representativeProfile(CoDebtorMapper.toDTO(domain.getRepresentativeProfile()))
                .build();
    }
}
