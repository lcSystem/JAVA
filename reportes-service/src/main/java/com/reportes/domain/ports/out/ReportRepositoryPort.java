package com.reportes.domain.ports.out;

import com.reportes.domain.model.ReportRequest;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ReportRepositoryPort {
    ReportRequest save(ReportRequest reportRequest);

    Optional<ReportRequest> findById(UUID id);

    List<ReportRequest> findByRequestedBy(String requestedBy);

    Optional<ReportRequest> findByEventId(String eventId); // For idempotency

    void saveProcessedEvent(String eventId);

    boolean isEventProcessed(String eventId);
}
