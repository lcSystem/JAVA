package com.allianceever.creditos.service;

import com.allianceever.creditos.model.ApplicantProfile;
import com.allianceever.creditos.model.CreditRequest;
import lombok.Data;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Service
public class ScoringService {

    @Data
    public static class ScoringResult {
        private String result; // APPROVED, REJECTED, MANUAL_REVIEW
        private String recommendation;
        private BigDecimal capacity;
    }

    public ScoringResult evaluate(CreditRequest request) {
        ApplicantProfile profile = request.getApplicant();
        ScoringResult scoring = new ScoringResult();

        // 1. Calcular Capacidad de Pago (Ingreso Neto - Gastos - Deudas)
        BigDecimal monthlyAvailable = profile.getMonthlyIncome()
                .subtract(profile.getMonthlyExpenses())
                .subtract(profile.getCurrentDebts());

        scoring.setCapacity(monthlyAvailable);

        // 2. Calcular cuota estimada (Simplificado: Interés Simple para el scoring)
        BigDecimal annualRate = request.getCreditType().getAnnualInterestRate().divide(new BigDecimal("100"), 4,
                RoundingMode.HALF_UP);
        BigDecimal monthlyRate = annualRate.divide(new BigDecimal("12"), 4, RoundingMode.HALF_UP);

        // Cuota aprox = (Monto / Plazo) + (Monto * tasa mensual)
        BigDecimal estimatedInstallment = request.getAmount()
                .divide(new BigDecimal(request.getTermMonths()), 2, RoundingMode.HALF_UP)
                .add(request.getAmount().multiply(monthlyRate));

        // 3. Reglas de Negocio

        // Regla A: La cuota no puede superar el 40% de la capacidad disponible
        BigDecimal maxInstallmentAllowed = monthlyAvailable.multiply(new BigDecimal("0.40"));

        // Regla B: Scoring mínimo (si existe)
        Integer score = profile.getCreditScore() != null ? profile.getCreditScore() : 0;

        if (estimatedInstallment.compareTo(maxInstallmentAllowed) > 0) {
            scoring.setResult("REJECTED");
            scoring.setRecommendation(
                    "Capacidad de pago insuficiente. El valor de la cuota supera el límite permitido.");
        } else if (score < 600) {
            scoring.setResult("MANUAL_REVIEW");
            scoring.setRecommendation(
                    "Puntaje crediticio bajo (" + score + "). Requiere revisión exhaustiva por un analista.");
        } else if (score >= 750
                && estimatedInstallment.compareTo(maxInstallmentAllowed.multiply(new BigDecimal("0.8"))) < 0) {
            scoring.setResult("APPROVED");
            scoring.setRecommendation(
                    "Cliente con excelente historial y alta capacidad de pago. Aprobación Automática sugerida.");
        } else {
            scoring.setResult("MANUAL_REVIEW");
            scoring.setRecommendation("Perfil de riesgo medio. Se recomienda verificación de documentos.");
        }

        return scoring;
    }
}
