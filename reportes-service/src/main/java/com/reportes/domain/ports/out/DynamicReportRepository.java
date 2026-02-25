package com.reportes.domain.ports.out;

import com.reportes.domain.model.dynamic.ReportTemplate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface DynamicReportRepository {
    ReportTemplate save(ReportTemplate template);

    Optional<ReportTemplate> findById(UUID id);

    List<ReportTemplate> findAll();

    void deleteById(UUID id);
}
