package com.reportes.application.services;

import com.reportes.domain.model.dynamic.StoredReportQuery;
import com.reportes.infrastructure.persistence.entity.StoredReportQueryEntity;
import com.reportes.infrastructure.persistence.repository.StoredReportQueryJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StoredReportQueryService {

    private final StoredReportQueryJpaRepository repository;

    public StoredReportQuery saveQuery(StoredReportQuery queryData, String username) {
        StoredReportQueryEntity entity = new StoredReportQueryEntity();
        if (queryData.getId() != null && !queryData.getId().isBlank()) {
            entity = repository.findById(queryData.getId()).orElse(new StoredReportQueryEntity());
        }

        entity.setName(queryData.getName());
        entity.setDescription(queryData.getDescription());
        entity.setSqlQuery(queryData.getSqlQuery());
        entity.setCreatedBy(username);

        StoredReportQueryEntity saved = repository.save(entity);
        return mapToDomain(saved);
    }

    public List<StoredReportQuery> getAllQueries() {
        return repository.findAllByOrderByCreatedAtDesc().stream()
                .map(this::mapToDomain)
                .collect(Collectors.toList());
    }

    public Optional<StoredReportQuery> getQueryById(String id) {
        return repository.findById(id).map(this::mapToDomain);
    }

    public void deleteQuery(String id) {
        repository.deleteById(id);
    }

    private StoredReportQuery mapToDomain(StoredReportQueryEntity entity) {
        return StoredReportQuery.builder()
                .id(entity.getId())
                .name(entity.getName())
                .description(entity.getDescription())
                .sqlQuery(entity.getSqlQuery())
                .createdBy(entity.getCreatedBy())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .build();
    }
}
