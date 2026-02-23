package com.allianceever.creditos.dto;

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
    private String debtorAdditionalInfo;
    private java.util.List<ReferenceDTO> debtorReferences;

    private java.util.List<CoDebtorProfileDTO> coDebtors;
    private CoDebtorProfileDTO representativeProfile;
}
