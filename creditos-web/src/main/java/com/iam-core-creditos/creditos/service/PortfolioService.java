package com.allianceever.creditos.service;

import com.allianceever.creditos.model.AmortizationInstallment;
import com.allianceever.creditos.model.CreditRequest;
import com.allianceever.creditos.repository.AmortizationInstallmentRepository;
import com.allianceever.creditos.repository.CreditRequestRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PortfolioService {

    private final CreditRequestRepository requestRepository;
    private final AmortizationInstallmentRepository installmentRepository;

    @Transactional
    public void updateOverdueInstallments() {
        LocalDate today = LocalDate.now();
        List<AmortizationInstallment> pending = installmentRepository.findAll().stream()
                .filter(i -> "PENDING".equals(i.getStatus()) && i.getDueDate().isBefore(today))
                .collect(Collectors.toList());

        pending.forEach(i -> i.setStatus("OVERDUE"));
        installmentRepository.saveAll(pending);
    }

    public Map<String, Object> getPortfolioSummary() {
        List<CreditRequest> allRequests = requestRepository.findAll();

        Map<String, Object> summary = new HashMap<>();
        summary.put("total_active_credits",
                allRequests.stream().filter(r -> "DISBURSED".equals(r.getStatus())).count());
        summary.put("total_paid_credits", allRequests.stream().filter(r -> "PAID".equals(r.getStatus())).count());

        List<AmortizationInstallment> overdue = installmentRepository.findAll().stream()
                .filter(i -> "OVERDUE".equals(i.getStatus()))
                .collect(Collectors.toList());

        summary.put("total_overdue_installments", overdue.size());
        summary.put("overdue_principal_risk", overdue.stream()
                .map(AmortizationInstallment::getPrincipalAmount)
                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add));

        return summary;
    }
}
