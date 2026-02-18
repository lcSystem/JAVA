package com.allianceever.creditos.controller;

import com.allianceever.creditos.dto.CreditRequestDTO;
import com.allianceever.creditos.service.CreditRequestService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/credit-requests")
@RequiredArgsConstructor
public class CreditRequestController {

    private final CreditRequestService creditRequestService;

    @PostMapping("/submit")
    @PreAuthorize("hasAuthority('CREDIT_CREATE')")
    public ResponseEntity<CreditRequestDTO> submitRequest(@RequestBody CreditRequestDTO dto,
            Authentication authentication) {
        // En una implementación real, el applicantUserId podría extraerse del token
        // Para este demo, permitimos pasarlo o podemos intentar inferirlo.
        return ResponseEntity.ok(creditRequestService.submitRequest(dto));
    }

    @PostMapping("/{id}/evaluate")
    @PreAuthorize("hasAuthority('CREDIT_APPROVE') or hasAuthority('CREDIT_ADMIN')")
    public ResponseEntity<CreditRequestDTO> evaluate(@PathVariable Long id) {
        return ResponseEntity.ok(creditRequestService.evaluateRequest(id));
    }

    @PostMapping("/{id}/approve")
    @PreAuthorize("hasAuthority('CREDIT_APPROVE') or hasAuthority('CREDIT_ADMIN')")
    public ResponseEntity<CreditRequestDTO> approve(@PathVariable Long id,
            @RequestParam(required = false) String comments, Authentication authentication) {
        return ResponseEntity.ok(creditRequestService.approveRequest(id, authentication.getName(), comments));
    }

    @PostMapping("/{id}/disburse")
    @PreAuthorize("hasAuthority('CREDIT_DISBURSE') or hasAuthority('CREDIT_ADMIN')")
    public ResponseEntity<CreditRequestDTO> disburse(@PathVariable Long id) {
        return ResponseEntity.ok(creditRequestService.disburseRequest(id));
    }

    @PostMapping("/{id}/restructure")
    @PreAuthorize("hasAuthority('CREDIT_RESTRUCTURE') or hasAuthority('CREDIT_ADMIN')")
    public ResponseEntity<CreditRequestDTO> restructure(@PathVariable Long id, @RequestParam Integer newTerm,
            @RequestParam(required = false) String comments, Authentication authentication) {
        return ResponseEntity
                .ok(creditRequestService.restructureCredit(id, newTerm, authentication.getName(), comments));
    }

    @GetMapping("/user/{userId}")
    @PreAuthorize("hasAuthority('CREDIT_READ')")
    public ResponseEntity<List<CreditRequestDTO>> getMyRequests(@PathVariable Long userId) {
        return ResponseEntity.ok(creditRequestService.getRequestsByUserId(userId));
    }
}
