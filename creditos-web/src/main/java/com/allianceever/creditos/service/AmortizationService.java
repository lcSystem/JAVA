package com.allianceever.creditos.service;

import com.allianceever.creditos.model.AmortizationInstallment;
import com.allianceever.creditos.model.CreditRequest;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class AmortizationService {

    /**
     * Calcula la tabla de amortización usando el Sistema Francés (Cuota Fija).
     */
    public List<AmortizationInstallment> generateFrenchSchedule(CreditRequest request) {
        List<AmortizationInstallment> schedule = new ArrayList<>();

        BigDecimal principal = request.getAmount();
        int terms = request.getTermMonths();
        BigDecimal annualRate = request.getCreditType().getAnnualInterestRate().divide(new BigDecimal("100"), 10,
                RoundingMode.HALF_UP);
        BigDecimal monthlyRate = annualRate.divide(new BigDecimal("12"), 10, RoundingMode.HALF_UP);

        // Cuota = P * [r(1+r)^n] / [(1+r)^n - 1]
        BigDecimal onePlusR = BigDecimal.ONE.add(monthlyRate);
        BigDecimal compoundInterest = onePlusR.pow(terms);

        BigDecimal numerator = principal.multiply(monthlyRate).multiply(compoundInterest);
        BigDecimal denominator = compoundInterest.subtract(BigDecimal.ONE);

        BigDecimal monthlyInstallment = numerator.divide(denominator, 2, RoundingMode.HALF_UP);

        BigDecimal remainingBalance = principal;
        LocalDate nextDueDate = LocalDate.now().plusMonths(1);

        for (int i = 1; i <= terms; i++) {
            BigDecimal interestPayment = remainingBalance.multiply(monthlyRate).setScale(2, RoundingMode.HALF_UP);
            BigDecimal principalPayment = monthlyInstallment.subtract(interestPayment);

            // Ajuste para la última cuota para evitar residuos por redondeo
            if (i == terms) {
                principalPayment = remainingBalance;
                monthlyInstallment = principalPayment.add(interestPayment);
                remainingBalance = BigDecimal.ZERO;
            } else {
                remainingBalance = remainingBalance.subtract(principalPayment);
            }

            AmortizationInstallment installment = AmortizationInstallment.builder()
                    .request(request)
                    .installmentNumber(i)
                    .dueDate(nextDueDate)
                    .principalAmount(principalPayment)
                    .interestAmount(interestPayment)
                    .totalInstallment(monthlyInstallment)
                    .remainingBalance(remainingBalance)
                    .status("PENDING")
                    .build();

            schedule.add(installment);
            nextDueDate = nextDueDate.plusMonths(1);
        }

        return schedule;
    }
}
