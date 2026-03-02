package com.portfolio.infrastructure.persistence.adapter;

import com.portfolio.domain.model.SystemSetting;
import com.portfolio.domain.ports.out.SettingsRepository;
import com.portfolio.infrastructure.persistence.entity.SystemSettingEntity;
import com.portfolio.infrastructure.persistence.repository.SpringDataSettingsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaSettingsRepositoryAdapter implements SettingsRepository {

    private final SpringDataSettingsRepository springRepository;

    @Override
    public List<SystemSetting> findAll() {
        return springRepository.findAll().stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<SystemSetting> findByKey(String key) {
        return springRepository.findByKey(key).map(this::toDomain);
    }

    @Override
    public SystemSetting save(SystemSetting setting) {
        SystemSettingEntity entity = toEntity(setting);
        SystemSettingEntity saved = springRepository.save(entity);
        return toDomain(saved);
    }

    private SystemSetting toDomain(SystemSettingEntity entity) {
        return SystemSetting.builder()
                .id(entity.getId())
                .key(entity.getKey())
                .value(entity.getValue())
                .description(entity.getDescription())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .build();
    }

    private SystemSettingEntity toEntity(SystemSetting setting) {
        return SystemSettingEntity.builder()
                .id(setting.getId())
                .key(setting.getKey())
                .value(setting.getValue())
                .description(setting.getDescription())
                .createdAt(setting.getCreatedAt())
                .updatedAt(setting.getUpdatedAt())
                .build();
    }
}
