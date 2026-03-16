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
                                .debtorAdditionalInfo(json)
                                .creditTypeName(domain.getCreditType().getName())
                                .interestRate(domain.getCreditType().getAnnualInterestRate())
                                .createdAt(domain.getCreatedAt())
                                .monthlyPayment(calculateMonthlyPayment(domain))
                                .totalPayment(calculateTotalPayment(domain))
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

        private static java.math.BigDecimal calculateMonthlyPayment(CreditRequest domain) {
                if (domain.getAmount() == null || domain.getTermMonths() == null || domain.getTermMonths() <= 0) {
                        return java.math.BigDecimal.ZERO;
                }
                java.math.BigDecimal annualRate = domain.getCreditType().getAnnualInterestRate()
                                .divide(new java.math.BigDecimal("100"), 10, java.math.RoundingMode.HALF_UP);
                java.math.BigDecimal monthlyRate = annualRate.divide(new java.math.BigDecimal("12"), 10,
                                java.math.RoundingMode.HALF_UP);

                if (monthlyRate.compareTo(java.math.BigDecimal.ZERO) == 0) {
                        return domain.getAmount().divide(new java.math.BigDecimal(domain.getTermMonths()), 2,
                                        java.math.RoundingMode.HALF_UP);
                }

                // P * [r(1+r)^n] / [(1+r)^n - 1]
                java.math.BigDecimal onePlusR = monthlyRate.add(java.math.BigDecimal.ONE);
                java.math.BigDecimal onePlusRToN = onePlusR.pow(domain.getTermMonths());
                java.math.BigDecimal numerator = monthlyRate.multiply(onePlusRToN);
                java.math.BigDecimal denominator = onePlusRToN.subtract(java.math.BigDecimal.ONE);

                return domain.getAmount().multiply(numerator.divide(denominator, 2, java.math.RoundingMode.HALF_UP));
        }

        private static java.math.BigDecimal calculateTotalPayment(CreditRequest domain) {
                java.math.BigDecimal monthly = calculateMonthlyPayment(domain);
                return monthly.multiply(new java.math.BigDecimal(domain.getTermMonths()));
        }
}
