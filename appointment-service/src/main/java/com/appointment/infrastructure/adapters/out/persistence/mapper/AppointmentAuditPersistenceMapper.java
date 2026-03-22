package com.appointment.infrastructure.adapters.out.persistence.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import com.appointment.domain.model.AppointmentAudit;
import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentAuditEntity;

@Mapper(componentModel = "spring")
public interface AppointmentAuditPersistenceMapper {
    AppointmentAuditPersistenceMapper INSTANCE = Mappers.getMapper(AppointmentAuditPersistenceMapper.class);

    AppointmentAuditEntity toEntity(AppointmentAudit audit);

    AppointmentAudit toDomain(AppointmentAuditEntity entity);
}
