package com.allianceever.creditos.domain.model;

import lombok.Getter;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
public class CreditRequest {
    private final Long id;
    private final Long applicantUserId;
    private final CreditType creditType;
    private final BigDecimal amount;
    private final Integer termMonths;
    private final String purpose;
    private final String status;
    private final String scoringResult;
    private final String scoringRecommendation;
    private final String coDebtorName;
    private final String coDebtorId;
    private final String representativeName;
    private final String representativeId;
    private final String debtorAdditionalInfo;
    private final CoDebtorProfile coDebtorProfile;
    private final CoDebtorProfile representativeProfile;
    private final LocalDateTime createdAt;

    public CreditRequest(Long id, Long applicantUserId, CreditType creditType, BigDecimal amount,
            Integer termMonths, String purpose, String status, String scoringResult,
            String scoringRecommendation, String coDebtorName, String coDebtorId,
            String representativeName, String representativeId, String debtorAdditionalInfo,
            CoDebtorProfile coDebtorProfile, CoDebtorProfile representativeProfile,
            LocalDateTime createdAt) {
        this.id = id;
        this.applicantUserId = applicantUserId;
        this.creditType = creditType;
        this.amount = amount;
        this.termMonths = termMonths;
        this.purpose = purpose;
        this.status = status;
        this.scoringResult = scoringResult;
        this.scoringRecommendation = scoringRecommendation;
        this.coDebtorName = coDebtorName;
        this.coDebtorId = coDebtorId;
        this.representativeName = representativeName;
        this.representativeId = representativeId;
        this.debtorAdditionalInfo = debtorAdditionalInfo;
        this.coDebtorProfile = coDebtorProfile;
        this.representativeProfile = representativeProfile;
        this.createdAt = createdAt;
    }
}
