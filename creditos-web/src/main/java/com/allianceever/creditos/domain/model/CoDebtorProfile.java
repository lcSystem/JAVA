package com.allianceever.creditos.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
@Builder
public class CoDebtorProfile {
    private final Long id;
    private final String fullName;
    private final String documentId;
    private final LocalDate birthDate;
    private final String phone;
    private final String address;
    private final String email;

    // Laboral Info
    private final String companyName;
    private final String position;
    private final Integer employmentYears;
    private final String workPhone;

    // Financial Info
    private final BigDecimal monthlyIncome;
    private final BigDecimal otherIncome;
    private final BigDecimal monthlyExpenses;

    private final boolean isLegalRepresentative;
    private final LocalDateTime createdAt;
    private final LocalDateTime updatedAt;
}
