package com.creditos.infrastructure.mappers;

import com.creditos.domain.model.CreditType;

public class CreditTypeMapper {
    public static CreditType toDomain(com.creditos.model.CreditType entity) {
        if (entity == null)
            return null;
        return new CreditType(
                entity.getId(),
                entity.getName(),
                entity.getDescription(),
                entity.getMinAmount(),
                entity.getMaxAmount(),
                entity.getMinTermMonths(),
                entity.getMaxTermMonths(),
                entity.getAnnualInterestRate(),
                entity.getPolicyDescription(),
                entity.getActive());
    }

    public static com.creditos.model.CreditType toEntity(CreditType domain) {
        if (domain == null)
            return null;
        com.creditos.model.CreditType entity = new com.creditos.model.CreditType();
        entity.setId(domain.getId());
        entity.setName(domain.getName());
        entity.setDescription(domain.getDescription());
        entity.setMinAmount(domain.getMinAmount());
        entity.setMaxAmount(domain.getMaxAmount());
        entity.setMinTermMonths(domain.getMinTermMonths());
        entity.setMaxTermMonths(domain.getMaxTermMonths());
        entity.setAnnualInterestRate(domain.getAnnualInterestRate());
        entity.setPolicyDescription(domain.getPolicyDescription());
        entity.setActive(domain.isActive());
        return entity;
    }
}
