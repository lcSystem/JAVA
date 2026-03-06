package com.creditos.domain.ports.in;

import com.creditos.domain.model.CreditRequest;
import java.math.BigDecimal;
import java.util.List;

public interface CreditRequestUseCase {
    CreditRequest submitRequest(Long applicantUserId, Long creditTypeId, BigDecimal amount, Integer termMonths,
            String purpose, String representativeName,
            String representativeId, String debtorAdditionalInfo,
            java.util.List<com.creditos.domain.model.Reference> debtorReferences,
            java.util.List<com.creditos.domain.model.CoDebtorProfile> coDebtors,
            java.util.List<com.creditos.domain.model.PreviousCredit> previousCredits,
            com.creditos.domain.model.CoDebtorProfile representativeProfile);

    CreditRequest evaluateRequest(Long requestId);

    CreditRequest approveRequest(Long requestId, String approver, String comments);

    CreditRequest disburseRequest(Long requestId);

    CreditRequest rejectRequest(Long requestId, String rejecter, String comments);

    CreditRequest restructureCredit(Long requestId, Integer newTerm, String approver, String comments);

    List<CreditRequest> getRequestsByUserId(Long userId);

    List<CreditRequest> getAllRequests();

    CreditRequest getRequestById(Long id);
}
