package com.reportes.domain.ports.out;

import com.reportes.domain.model.dynamic.DynamicReportHistory;
import java.util.List;

public interface DynamicReportHistoryRepositoryPort {
    DynamicReportHistory save(DynamicReportHistory history);

    List<DynamicReportHistory> findAllByOrderByCreatedAtDesc();
}
