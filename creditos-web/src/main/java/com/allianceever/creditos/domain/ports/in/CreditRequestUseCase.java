package com.allianceever.creditos.domain.ports.in;

import com.allianceever.creditos.domain.model.CreditRequest;
import java.math.BigDecimal;
import java.util.List;

public interface CreditRequestUseCase {
    CreditRequest submitRequest(Long applicantUserId, Long creditTypeId, BigDecimal amount, Integer termMonths,
            String purpose, String coDebtorName, String coDebtorId, String representativeName,
            String representativeId, String debtorAdditionalInfo,
            com.allianceever.creditos.domain.model.CoDebtorProfile coDebtorProfile,
            com.allianceever.creditos.domain.model.CoDebtorProfile representativeProfile);

    CreditRequest evaluateRequest(Long requestId);

    CreditRequest approveRequest(Long requestId, String approver, String comments);

    CreditRequest disburseRequest(Long requestId);

    CreditRequest restructureCredit(Long requestId, Integer newTerm, String approver, String comments);

    List<CreditRequest> getRequestsByUserId(Long userId);

    List<CreditRequest> getAllRequests();

    CreditRequest getRequestById(Long id);
}
