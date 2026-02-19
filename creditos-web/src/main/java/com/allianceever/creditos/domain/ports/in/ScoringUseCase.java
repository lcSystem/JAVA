package com.allianceever.creditos.domain.ports.in;

import com.allianceever.creditos.domain.model.CreditRequest;
import java.math.BigDecimal;

public interface ScoringUseCase {
    ScoringResult evaluate(CreditRequest request);

    @lombok.Data
    class ScoringResult {
        private String result;
        private String recommendation;
        private BigDecimal capacity;
    }
}
