package com.creditos.service;

import com.creditos.model.AmortizationInstallment;
import com.creditos.model.CreditRequest;
import com.creditos.repository.AmortizationInstallmentRepository;
import com.creditos.repository.CreditRequestRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
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

        @Scheduled(cron = "0 0 1 * * ?") // Every day at 1:00 AM
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
                List<CreditRequest> disbursedRequests = allRequests.stream()
                                .filter(r -> "DISBURSED".equals(r.getStatus()))
                                .collect(Collectors.toList());

                java.math.BigDecimal totalPortfolio = disbursedRequests.stream()
                                .map(CreditRequest::getAmount)
                                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);

                List<AmortizationInstallment> overdue = installmentRepository.findAll().stream()
                                .filter(i -> "OVERDUE".equals(i.getStatus()))
                                .collect(Collectors.toList());

                java.math.BigDecimal arrearsPortfolio = overdue.stream()
                                .map(AmortizationInstallment::getPrincipalAmount)
                                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);

                double arrearsRate = 0.0;
                if (totalPortfolio.compareTo(java.math.BigDecimal.ZERO) > 0) {
                        arrearsRate = arrearsPortfolio.divide(totalPortfolio, 4, java.math.RoundingMode.HALF_UP)
                                        .multiply(new java.math.BigDecimal("100")).doubleValue();
                }

                Map<String, Object> summary = new HashMap<>();
                summary.put("totalPortfolio", totalPortfolio);
                summary.put("activeCreditsCount", disbursedRequests.size());
                summary.put("arrearsPortfolio", arrearsPortfolio);
                summary.put("arrearsRate", arrearsRate);

                // Distribución por Tipo de Crédito
                Map<String, Long> distribution = disbursedRequests.stream()
                                .collect(Collectors.groupingBy(
                                                r -> r.getCreditType() != null ? r.getCreditType().getName() : "Otro",
                                                Collectors.counting()));
                summary.put("distributionByType", distribution);

                // Historial de Desembolsos (Últimos 6 meses)
                LocalDate sixMonthsAgo = LocalDate.now().minusMonths(6);
                Map<String, java.math.BigDecimal> history = disbursedRequests.stream()
                                .filter(r -> r.getCreatedAt() != null
                                                && r.getCreatedAt().toLocalDate().isAfter(sixMonthsAgo))
                                .collect(Collectors.groupingBy(
                                                r -> r.getCreatedAt().getMonth().name() + " "
                                                                + r.getCreatedAt().getYear(),
                                                Collectors.mapping(CreditRequest::getAmount,
                                                                Collectors.reducing(java.math.BigDecimal.ZERO,
                                                                                java.math.BigDecimal::add))));
                summary.put("disbursementHistory", history);

                return summary;
        }
}
