package com.reportes.infrastructure.delivery.rest;

import com.reportes.application.usecases.dynamic.GenerateDynamicReportUseCase;
import com.reportes.application.usecases.dynamic.ManageTemplateUseCase;
import com.reportes.application.services.dynamic.DynamicReportService; // for getHistory direct access for simplicity in demo
import com.reportes.domain.model.dynamic.ReportTemplate;
import com.reportes.domain.model.dynamic.DynamicReportHistory;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/dynamic-reports")
@RequiredArgsConstructor
public class DynamicReportController {

    private final ManageTemplateUseCase manageTemplateUseCase;
    private final GenerateDynamicReportUseCase generateDynamicReportUseCase;
    private final DynamicReportService dynamicReportService;

    @PostMapping("/templates")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ReportTemplate> createTemplate(@RequestBody ReportTemplate template) {
        return ResponseEntity.status(HttpStatus.CREATED).body(manageTemplateUseCase.createTemplate(template));
    }

    @PutMapping("/templates/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<ReportTemplate> updateTemplate(@PathVariable UUID id, @RequestBody ReportTemplate template) {
        return ResponseEntity.ok(manageTemplateUseCase.updateTemplate(id, template));
    }

    @GetMapping("/templates/{id}")
    public ResponseEntity<ReportTemplate> getTemplate(@PathVariable UUID id) {
        return ResponseEntity.ok(manageTemplateUseCase.getTemplate(id));
    }

    @GetMapping("/templates")
    public ResponseEntity<List<ReportTemplate>> getAllTemplates() {
        return ResponseEntity.ok(manageTemplateUseCase.getAllTemplates());
    }

    @DeleteMapping("/templates/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> deleteTemplate(@PathVariable UUID id) {
        manageTemplateUseCase.deleteTemplate(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/history")
    public ResponseEntity<List<DynamicReportHistory>> getReportHistory() {
        return ResponseEntity.ok(dynamicReportService.getReportHistory());
    }

    @PostMapping("/generate")
    public ResponseEntity<byte[]> generateReport(
            @RequestBody GenerateReportRequest request,
            @RequestHeader(value = "Authorization", required = false) String authHeader) {

        String username = "system";
        java.util.Set<String> roles = java.util.Set.of();

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof Jwt jwt) {
            username = jwt.getClaimAsString("preferred_username");
            if (username == null) {
                username = jwt.getSubject();
            }
            if (jwt.getClaimAsStringList("roles") != null) {
                roles = new java.util.HashSet<>(jwt.getClaimAsStringList("roles"));
            }
        }

        byte[] fileBytes = generateDynamicReportUseCase.generateReport(
                request.getTemplateId(),
                request.getDataSourceId(),
                request.getFilters(),
                request.getParameters(),
                request.getFormat(),
                authHeader,
                roles,
                username);

        HttpHeaders headers = new HttpHeaders();
        String filename = "report-" + UUID.randomUUID()
                + (request.getFormat().equalsIgnoreCase("EXCEL") ? ".xlsx" : ".pdf");

        headers.setContentType(request.getFormat().equalsIgnoreCase("EXCEL")
                ? MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
                : MediaType.APPLICATION_PDF);

        headers.setContentDispositionFormData("attachment", filename);

        return new ResponseEntity<>(fileBytes, headers, HttpStatus.OK);
    }

    @Data
    public static class GenerateReportRequest {
        private UUID templateId;
        private String dataSourceId;
        private Map<String, Object> filters;
        private Map<String, Object> parameters;
        private String format; // "PDF" or "EXCEL"
    }
}
