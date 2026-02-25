package com.reportes.application.usecases.dynamic;

import com.reportes.domain.model.dynamic.ReportTemplate;
import java.util.List;
import java.util.UUID;

public interface ManageTemplateUseCase {
    ReportTemplate createTemplate(ReportTemplate template);

    ReportTemplate updateTemplate(UUID id, ReportTemplate template);

    ReportTemplate getTemplate(UUID id);

    List<ReportTemplate> getAllTemplates();

    void deleteTemplate(UUID id);
}
