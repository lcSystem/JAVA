package com.creditos.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreditRequestDTO {
    private Long id;
    private Long applicantUserId;
    private Long creditTypeId;
    private BigDecimal amount;
    private Integer termMonths;
    private String purpose;
    private String status;
    private String scoringResult;
    private String representativeName;
    private String representativeId;
    private String applicantName;
    private String applicantIdentification;
    private String debtorAdditionalInfo;
    private String creditTypeName;
    private BigDecimal monthlyPayment;
    private BigDecimal totalPayment;
    private BigDecimal interestRate;
    private java.time.LocalDateTime createdAt;
    private java.util.List<ReferenceDTO> debtorReferences;

    private java.util.List<CoDebtorProfileDTO> coDebtors;
    private java.util.List<PreviousCreditDTO> previousCredits;
    private CoDebtorProfileDTO representativeProfile;
}
