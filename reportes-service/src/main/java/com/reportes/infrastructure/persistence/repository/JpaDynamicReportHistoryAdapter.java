package com.reportes.infrastructure.persistence.repository;

import com.reportes.domain.model.dynamic.DynamicReportHistory;
import com.reportes.domain.ports.out.DynamicReportHistoryRepositoryPort;
import com.reportes.infrastructure.persistence.entity.DynamicReportHistoryEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaDynamicReportHistoryAdapter implements DynamicReportHistoryRepositoryPort {

    private final SpringDataDynamicReportHistoryRepository repository;

    @Override
    public DynamicReportHistory save(DynamicReportHistory history) {
        DynamicReportHistoryEntity entity = toEntity(history);
        return toDomain(repository.save(entity));
    }

    @Override
    public List<DynamicReportHistory> findAllByOrderByCreatedAtDesc() {
        return repository.findAllByOrderByCreatedAtDesc().stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    private DynamicReportHistoryEntity toEntity(DynamicReportHistory domain) {
        return DynamicReportHistoryEntity.builder()
                .id(domain.getId())
                .templateId(domain.getTemplateId())
                .templateName(domain.getTemplateName())
                .microserviceId(domain.getMicroserviceId())
                .entityId(domain.getEntityId())
                .format(domain.getFormat())
                .createdBy(domain.getCreatedBy())
                .createdAt(domain.getCreatedAt())
                .build();
    }

    private DynamicReportHistory toDomain(DynamicReportHistoryEntity entity) {
        return DynamicReportHistory.builder()
                .id(entity.getId())
                .templateId(entity.getTemplateId())
                .templateName(entity.getTemplateName())
                .microserviceId(entity.getMicroserviceId())
                .entityId(entity.getEntityId())
                .format(entity.getFormat())
                .createdBy(entity.getCreatedBy())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
