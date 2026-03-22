package com.appointment.infrastructure.adapters.out.persistence.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.time.DayOfWeek;

import com.appointment.domain.model.Availability;
import com.appointment.infrastructure.adapters.out.persistence.entity.AvailabilityEntity;

@Mapper(componentModel = "spring")
public interface AvailabilityPersistenceMapper {
    AvailabilityPersistenceMapper INSTANCE = Mappers.getMapper(AvailabilityPersistenceMapper.class);

    AvailabilityEntity toEntity(Availability availability);

    Availability toDomain(AvailabilityEntity entity);

    default Integer mapDayOfWeek(DayOfWeek value) {
        return value != null ? value.getValue() : null;
    }

    default DayOfWeek mapDayOfWeek(Integer value) {
        return value != null ? DayOfWeek.of(value) : null;
    }
}
