package com.allianceever.creditos.infrastructure.mappers;

import com.allianceever.creditos.dto.CoDebtorProfileDTO;

public class CoDebtorMapper {
    public static com.allianceever.creditos.domain.model.CoDebtorProfile toDomain(
            com.allianceever.creditos.model.CoDebtorProfile entity) {
        if (entity == null)
            return null;
        return com.allianceever.creditos.domain.model.CoDebtorProfile.builder()
                .id(entity.getId())
                .fullName(entity.getFullName())
                .documentId(entity.getDocumentId())
                .birthDate(entity.getBirthDate())
                .phone(entity.getPhone())
                .address(entity.getAddress())
                .email(entity.getEmail())
                .companyName(entity.getCompanyName())
                .position(entity.getPosition())
                .employmentYears(entity.getEmploymentYears())
                .workPhone(entity.getWorkPhone())
                .monthlyIncome(entity.getMonthlyIncome())
                .otherIncome(entity.getOtherIncome())
                .monthlyExpenses(entity.getMonthlyExpenses())
                .isLegalRepresentative(entity.isLegalRepresentative())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .build();
    }

    public static com.allianceever.creditos.model.CoDebtorProfile toEntity(
            com.allianceever.creditos.domain.model.CoDebtorProfile domain) {
        if (domain == null)
            return null;
        return com.allianceever.creditos.model.CoDebtorProfile.builder()
                .id(domain.getId())
                .fullName(domain.getFullName())
                .documentId(domain.getDocumentId())
                .birthDate(domain.getBirthDate())
                .phone(domain.getPhone())
                .address(domain.getAddress())
                .email(domain.getEmail())
                .companyName(domain.getCompanyName())
                .position(domain.getPosition())
                .employmentYears(domain.getEmploymentYears())
                .workPhone(domain.getWorkPhone())
                .monthlyIncome(domain.getMonthlyIncome())
                .otherIncome(domain.getOtherIncome())
                .monthlyExpenses(domain.getMonthlyExpenses())
                .isLegalRepresentative(domain.isLegalRepresentative())
                .build();
    }

    public static CoDebtorProfileDTO toDTO(com.allianceever.creditos.domain.model.CoDebtorProfile domain) {
        if (domain == null)
            return null;
        return CoDebtorProfileDTO.builder()
                .id(domain.getId())
                .fullName(domain.getFullName())
                .documentId(domain.getDocumentId())
                .birthDate(domain.getBirthDate())
                .phone(domain.getPhone())
                .address(domain.getAddress())
                .email(domain.getEmail())
                .companyName(domain.getCompanyName())
                .position(domain.getPosition())
                .employmentYears(domain.getEmploymentYears())
                .workPhone(domain.getWorkPhone())
                .monthlyIncome(domain.getMonthlyIncome())
                .otherIncome(domain.getOtherIncome())
                .monthlyExpenses(domain.getMonthlyExpenses())
                .isLegalRepresentative(domain.isLegalRepresentative())
                .build();
    }

    public static com.allianceever.creditos.domain.model.CoDebtorProfile toDomain(CoDebtorProfileDTO dto) {
        if (dto == null)
            return null;
        return com.allianceever.creditos.domain.model.CoDebtorProfile.builder()
                .id(dto.getId())
                .fullName(dto.getFullName())
                .documentId(dto.getDocumentId())
                .birthDate(dto.getBirthDate())
                .phone(dto.getPhone())
                .address(dto.getAddress())
                .email(dto.getEmail())
                .companyName(dto.getCompanyName())
                .position(dto.getPosition())
                .employmentYears(dto.getEmploymentYears())
                .workPhone(dto.getWorkPhone())
                .monthlyIncome(dto.getMonthlyIncome())
                .otherIncome(dto.getOtherIncome())
                .monthlyExpenses(dto.getMonthlyExpenses())
                .isLegalRepresentative(dto.isLegalRepresentative())
                .build();
    }
}
