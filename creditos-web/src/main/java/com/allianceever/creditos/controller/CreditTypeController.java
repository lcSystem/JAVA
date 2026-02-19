package com.allianceever.creditos.controller;

import com.allianceever.creditos.model.CreditType;
import com.allianceever.creditos.service.CreditTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/credit-types")
@RequiredArgsConstructor
public class CreditTypeController {

    private final CreditTypeService creditTypeService;

    @GetMapping
    @PreAuthorize("hasAuthority('CREDIT_READ')")
    public ResponseEntity<List<CreditType>> getAllCreditTypes() {
        return ResponseEntity.ok(creditTypeService.getAllActiveCreditTypes());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('CREDIT_READ')")
    public ResponseEntity<CreditType> getCreditTypeById(@PathVariable Long id) {
        return ResponseEntity.ok(creditTypeService.getCreditTypeById(id));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('CREDIT_ADMIN') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<CreditType> createCreditType(
            @org.springframework.web.bind.annotation.RequestBody CreditType creditType) {
        return ResponseEntity.ok(creditTypeService.saveCreditType(creditType));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('CREDIT_ADMIN') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<CreditType> updateCreditType(@PathVariable Long id,
            @org.springframework.web.bind.annotation.RequestBody CreditType creditType) {
        return ResponseEntity.ok(creditTypeService.updateCreditType(id, creditType));
    }

    @org.springframework.web.bind.annotation.DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('CREDIT_ADMIN') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<Void> deleteCreditType(@PathVariable Long id) {
        creditTypeService.deleteCreditType(id);
        return ResponseEntity.noContent().build();
    }
}
