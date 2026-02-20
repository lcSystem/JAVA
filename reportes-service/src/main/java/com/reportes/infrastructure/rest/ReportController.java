package com.reportes.infrastructure.rest;

import com.reportes.domain.model.ReportRequest;
import com.reportes.domain.model.ReportType;
import com.reportes.domain.ports.in.GetReportStatusUseCase;
import com.reportes.domain.ports.in.RequestReportUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/reports")
@RequiredArgsConstructor
public class ReportController {

    private final RequestReportUseCase requestReportUseCase;
    private final GetReportStatusUseCase getReportStatusUseCase;

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('SCOPE_REPORT_READ')")
    public ResponseEntity<ReportRequest> getReport(@PathVariable UUID id) {
        return ResponseEntity.ok(getReportStatusUseCase.getReport(id));
    }

    @GetMapping("/user/{username}")
    @PreAuthorize("hasAuthority('SCOPE_REPORT_READ')")
    public ResponseEntity<List<ReportRequest>> getReportsByUser(@PathVariable String username) {
        return ResponseEntity.ok(getReportStatusUseCase.getReportsByUser(username));
    }

    @PostMapping("/manual")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UUID> triggerManualReport(
            @RequestParam ReportType type,
            @RequestBody String parameters,
            @RequestParam String requestedBy) {
        return ResponseEntity.ok(requestReportUseCase.initiateReport(type, parameters, requestedBy));
    }
}
