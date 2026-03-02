package com.projectERP.controller;

import com.projectERP.model.dto.PaymentDto;
import com.projectERP.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payment")
@ComponentScan(basePackages = "com.projectERP")
public class PaymentController {

    private PaymentService paymentService;

    @Autowired
    public PaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @GetMapping("/all")
    public ResponseEntity<List<PaymentDto>> getAllPayments() {
        return ResponseEntity.ok(paymentService.getAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<PaymentDto> getPaymentById(@PathVariable("id") Long id) {
        return ResponseEntity.ok(paymentService.getById(id));
    }

    @PostMapping("/create")
    public ResponseEntity<PaymentDto> createPayment(@RequestBody PaymentDto paymentDto) {
        return ResponseEntity.ok(paymentService.create(paymentDto));
    }

    // Mantener addPayment por compatibilidad si es necesario, pero create es
    // preferido
    @PostMapping("/addPayment")
    public ResponseEntity<PaymentDto> addPayment(@RequestBody PaymentDto request) {
        return ResponseEntity.ok(paymentService.create(request));
    }

    @PostMapping("/update")
    public ResponseEntity<PaymentDto> updatePayment(@RequestBody PaymentDto paymentDto) {
        if (paymentDto.getId() == null) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(paymentService.update(paymentDto.getId(), paymentDto));
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deletePayment(@PathVariable("id") Long id) {
        paymentService.delete(id);
        return ResponseEntity.ok("Payment deleted successfully!");
    }
}
