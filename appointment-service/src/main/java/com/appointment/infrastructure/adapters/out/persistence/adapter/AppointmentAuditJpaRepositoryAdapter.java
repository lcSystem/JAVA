package com.appointment.infrastructure.adapters.out.persistence.adapter;

import java.util.UUID;
import org.springframework.stereotype.Component;
import com.appointment.application.ports.out.AppointmentAuditRepositoryPort;
import com.appointment.domain.model.AppointmentAudit;
import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentAuditEntity;
import com.appointment.infrastructure.adapters.out.persistence.mapper.AppointmentAuditPersistenceMapper;
import com.appointment.infrastructure.adapters.out.persistence.repository.AppointmentAuditJpaRepository;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class AppointmentAuditJpaRepositoryAdapter implements AppointmentAuditRepositoryPort {
    private final AppointmentAuditJpaRepository repository;
    private final AppointmentAuditPersistenceMapper mapper;

    @Override
    public void save(AppointmentAudit audit) {
        if (audit.getId() == null) {
            audit.setId(UUID.randomUUID());
        }
        AppointmentAuditEntity entity = mapper.toEntity(audit);
        repository.save(entity);
    }
}
