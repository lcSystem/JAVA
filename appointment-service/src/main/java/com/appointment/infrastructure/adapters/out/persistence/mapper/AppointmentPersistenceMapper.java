package com.appointment.infrastructure.adapters.out.persistence.mapper;

import org.mapstruct.AfterMapping;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.factory.Mappers;

import com.appointment.domain.model.Appointment;
import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentEntity;

@Mapper(componentModel = "spring", unmappedTargetPolicy = org.mapstruct.ReportingPolicy.IGNORE)
public interface AppointmentPersistenceMapper {
    AppointmentPersistenceMapper INSTANCE = Mappers.getMapper(AppointmentPersistenceMapper.class);

    AppointmentEntity toEntity(Appointment appointment);

    Appointment toDomain(AppointmentEntity entity);

    @AfterMapping
    default void linkAttendees(@MappingTarget AppointmentEntity entity) {
        if (entity.getAttendees() != null) {
            entity.getAttendees().forEach(attendee -> attendee.setAppointment(entity));
        }
    }
}
