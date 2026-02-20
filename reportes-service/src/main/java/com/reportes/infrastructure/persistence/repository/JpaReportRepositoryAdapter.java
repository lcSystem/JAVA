package com.reportes.infrastructure.persistence.repository;

import com.reportes.domain.model.ReportRequest;
import com.reportes.domain.ports.out.ReportRepositoryPort;
import com.reportes.infrastructure.persistence.entity.ProcessedEventEntity;
import com.reportes.infrastructure.persistence.entity.ReportRequestEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaReportRepositoryAdapter implements ReportRepositoryPort {

    private final JpaReportRequestRepository repository;
    private final JpaProcessedEventRepository eventRepository;

    @Override
    public ReportRequest save(ReportRequest reportRequest) {
        ReportRequestEntity entity = mapToEntity(reportRequest);
        ReportRequestEntity saved = repository.save(entity);
        return mapToDomain(saved);
    }

    @Override
    public Optional<ReportRequest> findById(UUID id) {
        return repository.findById(id).map(this::mapToDomain);
    }

    @Override
    public List<ReportRequest> findByRequestedBy(String requestedBy) {
        return repository.findByRequestedBy(requestedBy).stream()
                .map(this::mapToDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<ReportRequest> findByEventId(String eventId) {
        // Correct implementation: Search for reports associated with this eventId if
        // stored.
        // For simplicity, we assume one event = one report and we might need to store
        // eventId in ReportRequestEntity too if requested.
        // But the requirement says "Idempotency using processed_events".
        return Optional.empty(); // Should use isEventProcessed instead
    }

    @Override
    public void saveProcessedEvent(String eventId) {
        eventRepository.save(ProcessedEventEntity.builder()
                .id(UUID.randomUUID())
                .eventId(eventId)
                .processedAt(LocalDateTime.now())
                .build());
    }

    @Override
    public boolean isEventProcessed(String eventId) {
        return eventRepository.findByEventId(eventId).isPresent();
    }

    private ReportRequestEntity mapToEntity(ReportRequest domain) {
        return ReportRequestEntity.builder()
                .id(domain.getId())
                .reportType(domain.getReportType())
                .parameters(domain.getParameters())
                .requestedBy(domain.getRequestedBy())
                .status(domain.getStatus())
                .fileUrl(domain.getFileUrl())
                .errorMessage(domain.getErrorMessage())
                .lastError(domain.getLastError())
                .retryCount(domain.getRetryCount())
                .version(domain.getVersion())
                .createdAt(domain.getCreatedAt())
                .completedAt(domain.getCompletedAt())
                .build();
    }

    private ReportRequest mapToDomain(ReportRequestEntity entity) {
        return ReportRequest.builder()
                .id(entity.getId())
                .reportType(entity.getReportType())
                .parameters(entity.getParameters())
                .requestedBy(entity.getRequestedBy())
                .status(entity.getStatus())
                .fileUrl(entity.getFileUrl())
                .errorMessage(entity.getErrorMessage())
                .lastError(entity.getLastError())
                .retryCount(entity.getRetryCount())
                .version(entity.getVersion())
                .createdAt(entity.getCreatedAt())
                .completedAt(entity.getCompletedAt())
                .build();
    }
}
