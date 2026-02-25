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
    public byte[] generateReport(UUID templateId, String rawData, Map<String, Object> parameters, String format,
            String microserviceId, String entityId, String requestedBy) {
        ReportTemplate template = getTemplate(templateId);

        log.info("Generating {} report for template: {}", format, templateId);

        byte[] resultBytes;
        if ("EXCEL".equalsIgnoreCase(format)) {
            resultBytes = excelGeneratorPort.generateExcel(template, rawData, parameters);
        } else {
            resultBytes = pdfGeneratorPort.generatePdf(template, rawData, parameters);
        }

        // Save history
        try {
            DynamicReportHistory history = DynamicReportHistory.builder()
                    .id(UUID.randomUUID())
                    .templateId(templateId)
                    .templateName(template.getName())
                    .microserviceId(microserviceId)
                    .entityId(entityId)
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

    public List<DynamicReportHistory> getReportHistory() {
        return historyRepositoryPort.findAllByOrderByCreatedAtDesc();
    }
}
