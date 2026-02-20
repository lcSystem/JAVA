package com.allianceever.creditos.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CoDebtorProfileDTO {
    private Long id;
    private String fullName;
    private String documentId;
    private LocalDate birthDate;
    private String phone;
    private String address;
    private String email;

    // Laboral Info
    private String companyName;
    private String position;
    private Integer employmentYears;
    private String workPhone;

    // Financial Info
    private BigDecimal monthlyIncome;
    private BigDecimal otherIncome;
    private BigDecimal monthlyExpenses;

    private boolean isLegalRepresentative;
    private List<CreditReferenceDTO> references;
}
