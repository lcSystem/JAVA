package com.allianceever.creditos.domain.ports.in;

import com.allianceever.creditos.domain.model.AmortizationInstallment;
import com.allianceever.creditos.domain.model.CreditRequest;
import java.util.List;

public interface AmortizationUseCase {
    List<AmortizationInstallment> generateFrenchSchedule(CreditRequest request);
}
