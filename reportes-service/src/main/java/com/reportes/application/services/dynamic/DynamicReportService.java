package com.reportes.application.services.dynamic;

import com.reportes.application.usecases.dynamic.GenerateDynamicReportUseCase;
import com.reportes.application.usecases.dynamic.ManageTemplateUseCase;
import com.reportes.domain.exception.ReportNotFoundException;
import com.reportes.domain.model.dynamic.ReportTemplate;
import com.reportes.domain.ports.out.DynamicExcelGeneratorPort;
import com.reportes.domain.ports.out.DynamicPdfGeneratorPort;
import com.reportes.domain.ports.out.DynamicReportRepository;
import com.reportes.domain.ports.out.DynamicReportHistoryRepositoryPort;
import com.reportes.domain.model.dynamic.DynamicReportHistory;
import com.reportes.domain.ports.out.DataSourcePort;
import com.reportes.domain.model.dynamic.ReportExecutionAudit;
import com.reportes.domain.ports.out.ReportExecutionAuditRepositoryPort;
import io.github.resilience4j.bulkhead.annotation.Bulkhead;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class DynamicReportService implements ManageTemplateUseCase, GenerateDynamicReportUseCase {

    private final DynamicReportRepository repository;
    private final DynamicPdfGeneratorPort pdfGeneratorPort;
    private final DynamicExcelGeneratorPort excelGeneratorPort;
    private final DynamicReportHistoryRepositoryPort historyRepositoryPort;
    private final List<DataSourcePort> dataSourcePorts;
    private final DataSourceRegistryService dataSourceRegistryService;
    private final ReportExecutionAuditRepositoryPort auditRepositoryPort;

    @Override
    @Transactional
    public ReportTemplate createTemplate(ReportTemplate template) {
        template.setId(UUID.randomUUID());
        template.setCreatedAt(LocalDateTime.now());
        template.setUpdatedAt(LocalDateTime.now());
        return repository.save(template);
    }

    @Override
    @Transactional
    public ReportTemplate updateTemplate(UUID id, ReportTemplate template) {
        ReportTemplate existing = getTemplate(id);
        existing.setName(template.getName());
        existing.setDescription(template.getDescription());
        existing.setConfig(template.getConfig());
        existing.setColumns(template.getColumns());
        existing.setCharts(template.getCharts());
        existing.setUpdatedAt(LocalDateTime.now());
        return repository.save(existing);
    }

    @Override
    @Transactional(readOnly = true)
    public ReportTemplate getTemplate(UUID id) {
        return repository.findById(id)
                .orElseThrow(() -> new ReportNotFoundException("Template not found: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReportTemplate> getAllTemplates() {
        return repository.findAll();
    }

    @Override
    @Transactional
    public void deleteTemplate(UUID id) {
        repository.deleteById(id);
    }

    @Override
    @Bulkhead(name = "reportGeneration")
    public byte[] generateReport(UUID templateId, String dataSourceId, Map<String, Object> filters,
            Map<String, Object> parameters, String format, String authToken, java.util.Set<String> userRoles,
            String requestedBy) {
        ReportTemplate template = getTemplate(templateId);

        log.info("Generating {} report for template: {} from source: {}", format, templateId, dataSourceId);

        if (!dataSourceRegistryService.isAllowed(dataSourceId, userRoles)) {
            saveAudit(requestedBy, dataSourceId, 0, "ERROR", "Access denied to data source");
            throw new org.springframework.security.access.AccessDeniedException(
                    "User is not authorized to access this data source");
        }

        DataSourcePort dataSource = dataSourcePorts.stream()
                .filter(port -> port.supports(dataSourceId))
                .findFirst()
                .orElseThrow(() -> {
                    saveAudit(requestedBy, dataSourceId, 0, "ERROR", "No adapter found for data source");
                    return new RuntimeException("No adapter found for data source: " + dataSourceId);
                });

        List<Map<String, Object>> rawDataList;
        try {
            rawDataList = dataSource.fetchData(dataSourceId, filters, authToken);
        } catch (Exception e) {
            saveAudit(requestedBy, dataSourceId, 0, "ERROR", "Error fetching data: " + e.getMessage());
            throw e;
        }

        byte[] resultBytes;
        try {
            if ("EXCEL".equalsIgnoreCase(format)) {
                resultBytes = excelGeneratorPort.generateExcel(template, rawDataList, parameters);
            } else {
                resultBytes = pdfGeneratorPort.generatePdf(template, rawDataList, parameters);
            }
        } catch (Exception e) {
            saveAudit(requestedBy, dataSourceId, rawDataList.size(), "ERROR",
                    "Error generating file: " + e.getMessage());
            throw e;
        }

        saveAudit(requestedBy, dataSourceId, rawDataList.size(), "SUCCESS", null);

        // Save history
        try {
            DynamicReportHistory history = DynamicReportHistory.builder()
                    .id(UUID.randomUUID())
                    .templateId(templateId)
                    .templateName(template.getName())
                    .microserviceId(dataSourceId) // Using dataSourceId for history traceability
                    .entityId("") // No longer applicable
                    .format(format)
                    .createdBy(requestedBy)
                    .createdAt(LocalDateTime.now())
                    .build();
            historyRepositoryPort.save(history);
        } catch (Exception e) {
            log.error("Failed to save report history", e);
        }

        return resultBytes;
    }

    private void saveAudit(String userId, String dataSourceId, int recordCount, String status, String errorMessage) {
        try {
            ReportExecutionAudit audit = ReportExecutionAudit.builder()
                    .id(UUID.randomUUID().toString())
                    .userId(userId)
                    .dataSourceId(dataSourceId)
                    .recordCount(recordCount)
                    .status(status)
                    .errorMessage(errorMessage)
                    .createdAt(LocalDateTime.now())
                    .build();
            auditRepositoryPort.save(audit);
        } catch (Exception e) {
            log.error("Failed to save report execution audit", e);
        }
    }

    public List<DynamicReportHistory> getReportHistory() {
        return historyRepositoryPort.findAllByOrderByCreatedAtDesc();
    }
}
