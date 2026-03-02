package com.creditos.service;

import com.creditos.domain.model.AmortizationInstallment;
import com.creditos.domain.model.CreditRequest;
import com.creditos.domain.ports.in.AmortizationUseCase;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class AmortizationService implements AmortizationUseCase {

    @Override
    public List<AmortizationInstallment> generateFrenchSchedule(CreditRequest request) {
        List<AmortizationInstallment> schedule = new ArrayList<>();

        BigDecimal principal = request.getAmount();
        int terms = request.getTermMonths();
        BigDecimal annualRate = request.getCreditType().getAnnualInterestRate().divide(new BigDecimal("100"), 10,
                RoundingMode.HALF_UP);
        BigDecimal monthlyRate = annualRate.divide(new BigDecimal("12"), 10, RoundingMode.HALF_UP);

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

            if (i == terms) {
                principalPayment = remainingBalance;
                monthlyInstallment = principalPayment.add(interestPayment);
                remainingBalance = BigDecimal.ZERO;
            } else {
                remainingBalance = remainingBalance.subtract(principalPayment);
            }

            AmortizationInstallment installment = new AmortizationInstallment(
                    null,
                    i,
                    nextDueDate,
                    principalPayment,
                    interestPayment,
                    BigDecimal.ZERO,
                    monthlyInstallment,
                    remainingBalance,
                    "PENDING");

            schedule.add(installment);
            nextDueDate = nextDueDate.plusMonths(1);
        }

        return schedule;
    }
}
