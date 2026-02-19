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
    private final LocalDateTime createdAt;

    public CreditRequest(Long id, Long applicantUserId, CreditType creditType, BigDecimal amount,
            Integer termMonths, String purpose, String status, String scoringResult,
            String scoringRecommendation, LocalDateTime createdAt) {
        this.id = id;
        this.applicantUserId = applicantUserId;
        this.creditType = creditType;
        this.amount = amount;
        this.termMonths = termMonths;
        this.purpose = purpose;
        this.status = status;
        this.scoringResult = scoringResult;
        this.scoringRecommendation = scoringRecommendation;
        this.createdAt = createdAt;
    }
}
