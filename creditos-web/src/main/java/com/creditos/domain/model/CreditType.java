package com.creditos.domain.model;

import lombok.Getter;
import java.math.BigDecimal;

@Getter
public class CreditType {
    private final Long id;
    private final String name;
    private final String description;
    private final BigDecimal minAmount;
    private final BigDecimal maxAmount;
    private final Integer minTermMonths;
    private final Integer maxTermMonths;
    private final BigDecimal annualInterestRate;
    private final String policyDescription;
    private final boolean active;

    public CreditType(Long id, String name, String description, BigDecimal minAmount, BigDecimal maxAmount,
            Integer minTermMonths, Integer maxTermMonths, BigDecimal annualInterestRate,
            String policyDescription, boolean active) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.minAmount = minAmount;
        this.maxAmount = maxAmount;
        this.minTermMonths = minTermMonths;
        this.maxTermMonths = maxTermMonths;
        this.annualInterestRate = annualInterestRate;
        this.policyDescription = policyDescription;
        this.active = active;
    }
}
