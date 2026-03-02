package com.creditos.controller;

import com.creditos.dto.CreditRequestDTO;
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

        private final com.creditos.domain.ports.in.CreditRequestUseCase creditRequestUseCase;

        @GetMapping
        @PreAuthorize("hasAuthority('CREDIT_READ') or hasAuthority('ROLE_ADMIN')")
        public ResponseEntity<List<CreditRequestDTO>> getAllRequests() {
                return ResponseEntity.ok(creditRequestUseCase.getAllRequests().stream()
                                .map(com.creditos.infrastructure.mappers.CreditRequestMapper::toDTO)
                                .collect(java.util.stream.Collectors.toList()));
        }

        @GetMapping("/{id}")
        @PreAuthorize("hasAuthority('CREDIT_READ') or hasAuthority('ROLE_ADMIN')")
        public ResponseEntity<CreditRequestDTO> getRequestById(@PathVariable Long id) {
                return ResponseEntity.ok(com.creditos.infrastructure.mappers.CreditRequestMapper
                                .toDTO(creditRequestUseCase.getRequestById(id)));
        }

        @PostMapping("/submit")
        @PreAuthorize("hasAuthority('CREDIT_SIM_CREATE') or hasAuthority('ROLE_ADMIN') or hasAuthority('CREDIT_CREATE')")
        public ResponseEntity<CreditRequestDTO> submitRequest(@RequestBody CreditRequestDTO dto,
                        Authentication authentication) {
                return ResponseEntity.ok(com.creditos.infrastructure.mappers.CreditRequestMapper.toDTO(
                                creditRequestUseCase.submitRequest(dto.getApplicantUserId(), dto.getCreditTypeId(),
                                                dto.getAmount(),
                                                dto.getTermMonths(), dto.getPurpose(),
                                                dto.getRepresentativeName(), dto.getRepresentativeId(),
                                                dto.getDebtorAdditionalInfo(),
                                                dto.getDebtorReferences() != null ? dto.getDebtorReferences().stream()
                                                                .map(com.creditos.infrastructure.mappers.ReferenceMapper::toDomain)
                                                                .collect(java.util.stream.Collectors.toList()) : null,
                                                dto.getCoDebtors() != null ? dto.getCoDebtors().stream()
                                                                .map(com.creditos.infrastructure.mappers.CoDebtorMapper::toDomain)
                                                                .collect(java.util.stream.Collectors.toList()) : null,
                                                com.creditos.infrastructure.mappers.CoDebtorMapper
                                                                .toDomain(dto.getRepresentativeProfile()))));
        }

        @PostMapping("/{id}/evaluate")
        @PreAuthorize("hasAuthority('CREDIT_APP_UPDATE') or hasAuthority('CREDIT_APPROVE') or hasAuthority('ROLE_ADMIN') or hasAuthority('CREDIT_ADMIN')")
        public ResponseEntity<CreditRequestDTO> evaluate(@PathVariable Long id) {
                return ResponseEntity.ok(com.creditos.infrastructure.mappers.CreditRequestMapper
                                .toDTO(creditRequestUseCase.evaluateRequest(id)));
        }

        @PostMapping("/{id}/approve")
        @PreAuthorize("hasAuthority('CREDIT_APP_UPDATE') or hasAuthority('CREDIT_APPROVE') or hasAuthority('ROLE_ADMIN') or hasAuthority('CREDIT_ADMIN')")
        public ResponseEntity<CreditRequestDTO> approve(@PathVariable Long id,
                        @RequestParam(required = false) String comments, Authentication authentication) {
                return ResponseEntity.ok(com.creditos.infrastructure.mappers.CreditRequestMapper
                                .toDTO(creditRequestUseCase.approveRequest(id, authentication.getName(), comments)));
        }

        @PostMapping("/{id}/disburse")
        @PreAuthorize("hasAuthority('CREDIT_APP_UPDATE') or hasAuthority('CREDIT_DISBURSE') or hasAuthority('ROLE_ADMIN') or hasAuthority('CREDIT_ADMIN')")
        public ResponseEntity<CreditRequestDTO> disburse(@PathVariable Long id) {
                return ResponseEntity.ok(com.creditos.infrastructure.mappers.CreditRequestMapper
                                .toDTO(creditRequestUseCase.disburseRequest(id)));
        }

        @PostMapping("/{id}/restructure")
        @PreAuthorize("hasAuthority('CREDIT_PORT_UPDATE') or hasAuthority('CREDIT_RESTRUCTURE') or hasAuthority('ROLE_ADMIN') or hasAuthority('CREDIT_ADMIN')")
        public ResponseEntity<CreditRequestDTO> restructure(@PathVariable Long id, @RequestParam Integer newTerm,
                        @RequestParam(required = false) String comments, Authentication authentication) {
                return ResponseEntity
                                .ok(com.creditos.infrastructure.mappers.CreditRequestMapper.toDTO(
                                                creditRequestUseCase.restructureCredit(id, newTerm,
                                                                authentication.getName(), comments)));
        }

        @GetMapping("/user/{userId}")
        @PreAuthorize("hasAuthority('CREDIT_READ') or hasAuthority('ROLE_ADMIN')")
        public ResponseEntity<List<CreditRequestDTO>> getMyRequests(@PathVariable Long userId) {
                return ResponseEntity.ok(creditRequestUseCase.getRequestsByUserId(userId).stream()
                                .map(com.creditos.infrastructure.mappers.CreditRequestMapper::toDTO)
                                .collect(java.util.stream.Collectors.toList()));
        }
}
