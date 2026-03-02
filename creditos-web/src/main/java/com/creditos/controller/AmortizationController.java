package com.creditos.controller;

import com.creditos.domain.model.AmortizationInstallment;
import com.creditos.domain.model.CreditRequest;
import com.creditos.domain.ports.in.AmortizationUseCase;
import com.creditos.domain.ports.in.CreditRequestUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/amortization")
@RequiredArgsConstructor
public class AmortizationController {

    private final AmortizationUseCase amortizationUseCase;
    private final CreditRequestUseCase creditRequestUseCase;

    @GetMapping("/request/{requestId}")
    public ResponseEntity<List<AmortizationInstallment>> getScheduleByRequest(@PathVariable Long requestId) {
        CreditRequest request = creditRequestUseCase.getRequestById(requestId);
        return ResponseEntity.ok(amortizationUseCase.generateFrenchSchedule(request));
    }
}
