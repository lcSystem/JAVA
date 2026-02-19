package com.allianceever.creditos.application.services;

import com.allianceever.creditos.domain.model.CreditRequest;
import com.allianceever.creditos.domain.model.CreditType;
import com.allianceever.creditos.domain.ports.in.CreditRequestUseCase;
import com.allianceever.creditos.domain.ports.out.CreditRequestRepositoryPort;
import com.allianceever.creditos.domain.ports.out.CreditTypeRepositoryPort;
import lombok.RequiredArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@RequiredArgsConstructor
public class CreditRequestUseCaseImpl implements CreditRequestUseCase {

    private final CreditRequestRepositoryPort creditRequestRepositoryPort;
    private final CreditTypeRepositoryPort creditTypeRepositoryPort;
    private final com.allianceever.creditos.domain.ports.in.ScoringUseCase scoringUseCase;
    private final com.allianceever.creditos.domain.ports.in.AmortizationUseCase amortizationUseCase;

    @Override
    public CreditRequest submitRequest(Long applicantUserId, Long creditTypeId, BigDecimal amount, Integer termMonths,
            String purpose) {
        CreditType type = creditTypeRepositoryPort.findById(creditTypeId)
                .orElseThrow(() -> new RuntimeException("Credit type not found"));

        validateCreditPolicy(amount, termMonths, type);

        CreditRequest request = new CreditRequest(
                null,
                applicantUserId,
                type,
                amount,
                termMonths,
                purpose,
                "EVALUATING",
                null,
                null,
                null);

        return creditRequestRepositoryPort.save(request);
    }

    private void validateCreditPolicy(BigDecimal amount, Integer termMonths, CreditType type) {
        if (amount.compareTo(type.getMinAmount()) < 0 || amount.compareTo(type.getMaxAmount()) > 0) {
            throw new RuntimeException("Amount out of allowed range for type: " + type.getName());
        }
        if (termMonths < type.getMinTermMonths() || termMonths > type.getMaxTermMonths()) {
            throw new RuntimeException("Term out of allowed range for type: " + type.getName());
        }
    }

    @Override
    public CreditRequest evaluateRequest(Long requestId) {
        CreditRequest request = creditRequestRepositoryPort.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found"));

        com.allianceever.creditos.domain.ports.in.ScoringUseCase.ScoringResult result = scoringUseCase
                .evaluate(request);

        CreditRequest evaluatedRequest = new CreditRequest(
                request.getId(),
                request.getApplicantUserId(),
                request.getCreditType(),
                request.getAmount(),
                request.getTermMonths(),
                request.getPurpose(),
                request.getStatus(),
                result.getResult(),
                result.getRecommendation(),
                request.getCreatedAt());

        return creditRequestRepositoryPort.save(evaluatedRequest);
    }

    @Override
    public CreditRequest approveRequest(Long requestId, String approver, String comments) {
        CreditRequest request = creditRequestRepositoryPort.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found"));

        CreditRequest approvedRequest = new CreditRequest(
                request.getId(),
                request.getApplicantUserId(),
                request.getCreditType(),
                request.getAmount(),
                request.getTermMonths(),
                request.getPurpose(),
                "APPROVED",
                request.getScoringResult(),
                request.getScoringRecommendation(),
                request.getCreatedAt());

        return creditRequestRepositoryPort.save(approvedRequest);
    }

    @Override
    public CreditRequest disburseRequest(Long requestId) {
        CreditRequest request = creditRequestRepositoryPort.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found"));

        if (!"APPROVED".equals(request.getStatus())) {
            throw new RuntimeException("Request must be APPROVED to be disbursed");
        }

        // Amortization logic here if needed (saving installments)
        // Usually the adapter handles the side effects or we have another port for
        // installments

        CreditRequest disbursedRequest = new CreditRequest(
                request.getId(),
                request.getApplicantUserId(),
                request.getCreditType(),
                request.getAmount(),
                request.getTermMonths(),
                request.getPurpose(),
                "DISBURSED",
                request.getScoringResult(),
                request.getScoringRecommendation(),
                request.getCreatedAt());

        return creditRequestRepositoryPort.save(disbursedRequest);
    }

    @Override
    public CreditRequest restructureCredit(Long requestId, Integer newTerm, String approver, String comments) {
        // Implementation for restructuring
        return null;
    }

    @Override
    public List<CreditRequest> getRequestsByUserId(Long userId) {
        return creditRequestRepositoryPort.findByApplicantUserId(userId);
    }
}
