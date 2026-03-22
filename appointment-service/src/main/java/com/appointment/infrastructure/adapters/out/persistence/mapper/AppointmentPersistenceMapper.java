package com.appointment.infrastructure.adapters.out.persistence.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import com.appointment.domain.model.Appointment;
import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentEntity;

@Mapper(componentModel = "spring")
public interface AppointmentPersistenceMapper {
    AppointmentPersistenceMapper INSTANCE = Mappers.getMapper(AppointmentPersistenceMapper.class);

    AppointmentEntity toEntity(Appointment appointment);

    Appointment toDomain(AppointmentEntity entity);
}
