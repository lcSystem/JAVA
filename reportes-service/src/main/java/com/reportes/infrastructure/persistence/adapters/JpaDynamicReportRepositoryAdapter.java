package com.reportes.infrastructure.persistence.adapters;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.reportes.domain.model.dynamic.ReportChart;
import com.reportes.domain.model.dynamic.ReportColumn;
import com.reportes.domain.model.dynamic.ReportConfig;
import com.reportes.domain.model.dynamic.ReportTemplate;
import com.reportes.domain.ports.out.DynamicReportRepository;
import com.reportes.infrastructure.persistence.entities.ReportTemplateEntity;
import com.reportes.infrastructure.persistence.repositories.SpringDataReportTemplateRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
@Slf4j
public class JpaDynamicReportRepositoryAdapter implements DynamicReportRepository {

    private final SpringDataReportTemplateRepository repository;
    private final ObjectMapper objectMapper;

    @Override
    public ReportTemplate save(ReportTemplate template) {
        ReportTemplateEntity entity = mapToEntity(template);
        ReportTemplateEntity saved = repository.save(entity);
        return mapToDomain(saved);
    }

    @Override
    public Optional<ReportTemplate> findById(UUID id) {
        return repository.findById(id).map(this::mapToDomain);
    }

    @Override
    public List<ReportTemplate> findAll() {
        return repository.findAll().stream().map(this::mapToDomain).collect(Collectors.toList());
    }

    @Override
    public void deleteById(UUID id) {
        repository.deleteById(id);
    }

    private ReportTemplateEntity mapToEntity(ReportTemplate domain) {
        try {
            return ReportTemplateEntity.builder()
                    .id(domain.getId())
                    .name(domain.getName())
                    .description(domain.getDescription())
                    .config(objectMapper.writeValueAsString(domain.getConfig()))
                    .columns(objectMapper.writeValueAsString(domain.getColumns()))
                    .charts(objectMapper.writeValueAsString(domain.getCharts()))
                    .createdBy(domain.getCreatedBy())
                    .createdAt(domain.getCreatedAt())
                    .updatedAt(domain.getUpdatedAt())
                    .build();
        } catch (JsonProcessingException e) {
            log.error("Error serializing json for ReportTemplateEntity", e);
            throw new RuntimeException("Failed to serialize template json", e);
        }
    }

    private ReportTemplate mapToDomain(ReportTemplateEntity entity) {
        try {
            ReportConfig config = entity.getConfig() != null
                    ? objectMapper.readValue(entity.getConfig(), ReportConfig.class)
                    : new ReportConfig();
            List<ReportColumn> columns = entity.getColumns() != null
                    ? objectMapper.readValue(entity.getColumns(), new TypeReference<>() {
                    })
                    : List.of();
            List<ReportChart> charts = entity.getCharts() != null
                    ? objectMapper.readValue(entity.getCharts(), new TypeReference<>() {
                    })
                    : List.of();

            return ReportTemplate.builder()
                    .id(entity.getId())
                    .name(entity.getName())
                    .description(entity.getDescription())
                    .config(config)
                    .columns(columns)
                    .charts(charts)
                    .createdBy(entity.getCreatedBy())
                    .createdAt(entity.getCreatedAt())
                    .updatedAt(entity.getUpdatedAt())
                    .build();
        } catch (JsonProcessingException e) {
            log.error("Error deserializing json from ReportTemplateEntity", e);
            throw new RuntimeException("Failed to deserialize template json", e);
        }
    }
}
