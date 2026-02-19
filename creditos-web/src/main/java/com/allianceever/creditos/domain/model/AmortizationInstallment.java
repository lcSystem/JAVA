package com.allianceever.creditos.domain.model;

import lombok.Getter;
import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
public class AmortizationInstallment {
    private final Long id;
    private final Integer installmentNumber;
    private final LocalDate dueDate;
    private final BigDecimal principalAmount;
    private final BigDecimal interestAmount;
    private final BigDecimal insuranceAmount;
    private final BigDecimal totalInstallment;
    private final BigDecimal remainingBalance;
    private final String status;

    public AmortizationInstallment(Long id, Integer installmentNumber, LocalDate dueDate,
            BigDecimal principalAmount, BigDecimal interestAmount,
            BigDecimal insuranceAmount, BigDecimal totalInstallment,
            BigDecimal remainingBalance, String status) {
        this.id = id;
        this.installmentNumber = installmentNumber;
        this.dueDate = dueDate;
        this.principalAmount = principalAmount;
        this.interestAmount = interestAmount;
        this.insuranceAmount = insuranceAmount;
        this.totalInstallment = totalInstallment;
        this.remainingBalance = remainingBalance;
        this.status = status;
    }
}
