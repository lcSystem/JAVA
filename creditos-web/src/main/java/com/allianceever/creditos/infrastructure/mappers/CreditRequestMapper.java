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
                entity.getDebtorAdditionalInfo(),
                entity.getDebtorReferences() != null ? entity.getDebtorReferences().stream()
                        .map(ReferenceMapper::toDomain)
                        .collect(java.util.stream.Collectors.toList()) : new java.util.ArrayList<>(),
                entity.getCoDebtors() != null ? entity.getCoDebtors().stream()
                        .map(CoDebtorMapper::toDomain)
                        .collect(java.util.stream.Collectors.toList()) : new java.util.ArrayList<>(),
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
        entity.setDebtorAdditionalInfo(domain.getDebtorAdditionalInfo());
        entity.setDebtorReferences(domain.getDebtorReferences() != null ? domain.getDebtorReferences().stream()
                .map(ReferenceMapper::toEntity)
                .collect(java.util.stream.Collectors.toList()) : new java.util.ArrayList<>());
        entity.setCoDebtors(domain.getCoDebtors() != null ? domain.getCoDebtors().stream()
                .map(CoDebtorMapper::toEntity)
                .collect(java.util.stream.Collectors.toList()) : new java.util.ArrayList<>());
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
                .representativeName(
                        domain.getRepresentativeProfile() != null ? domain.getRepresentativeProfile().getFullName()
                                : null)
                .representativeId(
                        domain.getRepresentativeProfile() != null ? domain.getRepresentativeProfile().getDocumentId()
                                : null)
                .debtorAdditionalInfo(domain.getDebtorAdditionalInfo())
                .debtorReferences(domain.getDebtorReferences() != null ? domain.getDebtorReferences().stream()
                        .map(ReferenceMapper::toDTO)
                        .collect(java.util.stream.Collectors.toList()) : new java.util.ArrayList<>())
                .coDebtors(domain.getCoDebtors() != null ? domain.getCoDebtors().stream()
                        .map(CoDebtorMapper::toDTO)
                        .collect(java.util.stream.Collectors.toList()) : new java.util.ArrayList<>())
                .representativeProfile(CoDebtorMapper.toDTO(domain.getRepresentativeProfile()))
                .build();
    }
}
