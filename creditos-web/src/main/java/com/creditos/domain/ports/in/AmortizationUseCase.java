package com.creditos.domain.ports.in;

import com.creditos.domain.model.AmortizationInstallment;
import com.creditos.domain.model.CreditRequest;
import java.util.List;

public interface AmortizationUseCase {
    List<AmortizationInstallment> generateFrenchSchedule(CreditRequest request);
}
