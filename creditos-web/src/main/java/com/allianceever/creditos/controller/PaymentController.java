package com.allianceever.creditos.controller;

import com.allianceever.creditos.dto.PaymentDTO;
import com.allianceever.creditos.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @PostMapping("/register")
    @PreAuthorize("hasAuthority('CREDIT_PAY') or hasAuthority('CREDIT_ADMIN') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<PaymentDTO> registerPayment(@RequestBody PaymentDTO dto) {
        return ResponseEntity.ok(paymentService.registerPayment(dto));
    }
}
