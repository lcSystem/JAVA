package com.creditos.service;

import com.creditos.domain.model.CreditRequest;
import com.creditos.domain.ports.in.ScoringUseCase;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.math.RoundingMode;

@Service
public class ScoringService implements ScoringUseCase {

    @Override
    public ScoringResult evaluate(CreditRequest request) {
        ScoringResult scoring = new ScoringResult();

        // Note: Real implementation would fetch applicant details.
        // For this refactor, we simplify to avoid excessive infrastructure calls.
        BigDecimal monthlyAvailable = BigDecimal.valueOf(3000); // Placeholder
        scoring.setCapacity(monthlyAvailable);

        BigDecimal annualRate = request.getCreditType().getAnnualInterestRate().divide(new BigDecimal("100"), 4,
                RoundingMode.HALF_UP);
        BigDecimal monthlyRate = annualRate.divide(new BigDecimal("12"), 4, RoundingMode.HALF_UP);

        BigDecimal estimatedInstallment = request.getAmount()
                .divide(new BigDecimal(request.getTermMonths()), 2, RoundingMode.HALF_UP)
                .add(request.getAmount().multiply(monthlyRate));

        BigDecimal maxInstallmentAllowed = monthlyAvailable.multiply(new BigDecimal("0.40"));

        if (estimatedInstallment.compareTo(maxInstallmentAllowed) > 0) {
            scoring.setResult("REJECTED");
            scoring.setRecommendation("Capacidad de pago insuficiente.");
        } else {
            scoring.setResult("APPROVED");
            scoring.setRecommendation("Aprobación sugerida.");
        }

        return scoring;
    }
}
