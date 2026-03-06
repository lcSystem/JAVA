package com.creditos.infrastructure.mappers;

import com.creditos.domain.model.CreditRequest;
import com.creditos.dto.CreditRequestDTO;

public class CreditRequestMapper {
        public static CreditRequest toDomain(com.creditos.model.CreditRequest entity) {
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
                                                .collect(java.util.stream.Collectors.toList())
                                                : new java.util.ArrayList<>(),
                                entity.getCoDebtors() != null ? entity.getCoDebtors().stream()
                                                .map(CoDebtorMapper::toDomain)
                                                .collect(java.util.stream.Collectors.toList())
                                                : new java.util.ArrayList<>(),
                                entity.getPreviousCredits() != null ? entity.getPreviousCredits().stream()
                                                .map(PreviousCreditMapper::toDomain)
                                                .collect(java.util.stream.Collectors.toList())
                                                : new java.util.ArrayList<>(),
                                CoDebtorMapper.toDomain(entity.getRepresentativeProfile()),
                                entity.getCreatedAt());
        }

        public static com.creditos.model.CreditRequest toEntity(CreditRequest domain) {
                if (domain == null)
                        return null;
                com.creditos.model.CreditRequest entity = new com.creditos.model.CreditRequest();
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
                entity.setPreviousCredits(domain.getPreviousCredits() != null ? domain.getPreviousCredits().stream()
                                .map(PreviousCreditMapper::toEntity)
                                .collect(java.util.stream.Collectors.toList()) : new java.util.ArrayList<>());
                entity.setRepresentativeProfile(CoDebtorMapper.toEntity(domain.getRepresentativeProfile()));
                return entity;
        }

        public static CreditRequestDTO toDTO(CreditRequest domain) {
                if (domain == null)
                        return null;

                String applicantName = null;
                String applicantIdentification = null;

                // Parse debtorAdditionalInfo to extract applicant name and ID
                String json = domain.getDebtorAdditionalInfo();
                if (json != null && !json.isBlank()) {
                        try {
                                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                                com.fasterxml.jackson.databind.JsonNode root = mapper.readTree(json);

                                // Check if it's the new nested format { "debtor": { ... } } or old flat format
                                com.fasterxml.jackson.databind.JsonNode debtor = root.has("debtor") ? root.get("debtor")
                                                : root;

                                if (debtor.has("fullName")) {
                                        applicantName = debtor.get("fullName").asText();
                                }
                                if (debtor.has("documentId")) {
                                        applicantIdentification = debtor.get("documentId").asText();
                                }
                        } catch (Exception e) {
                                // Silent fall-through if parsing fails
                        }
                }

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
                                                domain.getRepresentativeProfile() != null
                                                                ? domain.getRepresentativeProfile().getFullName()
                                                                : null)
                                .representativeId(
                                                domain.getRepresentativeProfile() != null
                                                                ? domain.getRepresentativeProfile().getDocumentId()
                                                                : null)
                                .applicantName(applicantName)
                                .applicantIdentification(applicantIdentification)
                                .debtorAdditionalInfo(domain.getDebtorAdditionalInfo())
                                .debtorReferences(
                                                domain.getDebtorReferences() != null
                                                                ? domain.getDebtorReferences().stream()
                                                                                .map(ReferenceMapper::toDTO)
                                                                                .collect(java.util.stream.Collectors
                                                                                                .toList())
                                                                : new java.util.ArrayList<>())
                                .coDebtors(domain.getCoDebtors() != null ? domain.getCoDebtors().stream()
                                                .map(CoDebtorMapper::toDTO)
                                                .collect(java.util.stream.Collectors.toList())
                                                : new java.util.ArrayList<>())
                                .previousCredits(
                                                domain.getPreviousCredits() != null
                                                                ? domain.getPreviousCredits().stream()
                                                                                .map(PreviousCreditMapper::toDTO)
                                                                                .collect(java.util.stream.Collectors
                                                                                                .toList())
                                                                : new java.util.ArrayList<>())
                                .representativeProfile(CoDebtorMapper.toDTO(domain.getRepresentativeProfile()))
                                .build();
        }
}
