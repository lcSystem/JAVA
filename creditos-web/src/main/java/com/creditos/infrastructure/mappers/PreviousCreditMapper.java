package com.creditos.infrastructure.mappers;

import com.creditos.domain.model.PreviousCredit;
import com.creditos.dto.PreviousCreditDTO;

public class PreviousCreditMapper {
    public static PreviousCredit toDomain(com.creditos.model.PreviousCredit entity) {
        if (entity == null)
            return null;
        return PreviousCredit.builder()
                .id(entity.getId())
                .bankName(entity.getBankName())
                .amount(entity.getAmount())
                .status(entity.getStatus())
                .monthlyInstallment(entity.getMonthlyInstallment())
                .build();
    }

    public static com.creditos.model.PreviousCredit toEntity(PreviousCredit domain) {
        if (domain == null)
            return null;
        com.creditos.model.PreviousCredit entity = new com.creditos.model.PreviousCredit();
        entity.setId(domain.getId());
        entity.setBankName(domain.getBankName());
        entity.setAmount(domain.getAmount());
        entity.setStatus(domain.getStatus());
        entity.setMonthlyInstallment(domain.getMonthlyInstallment());
        return entity;
    }

    public static PreviousCreditDTO toDTO(PreviousCredit domain) {
        if (domain == null)
            return null;
        return PreviousCreditDTO.builder()
                .bankName(domain.getBankName())
                .amount(domain.getAmount())
                .status(domain.getStatus())
                .monthlyInstallment(domain.getMonthlyInstallment())
                .build();
    }

    public static PreviousCredit toDomain(PreviousCreditDTO dto) {
        if (dto == null)
            return null;
        return PreviousCredit.builder()
                .bankName(dto.getBankName())
                .amount(dto.getAmount())
                .status(dto.getStatus())
                .monthlyInstallment(dto.getMonthlyInstallment())
                .build();
    }
}
