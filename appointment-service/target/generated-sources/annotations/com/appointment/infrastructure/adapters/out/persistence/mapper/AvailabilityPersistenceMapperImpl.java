package com.appointment.infrastructure.adapters.out.persistence.mapper;

import com.appointment.domain.model.Availability;
import com.appointment.infrastructure.adapters.out.persistence.entity.AvailabilityEntity;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-03-22T00:02:12-0500",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 21.0.10 (Ubuntu)"
)
@Component
public class AvailabilityPersistenceMapperImpl implements AvailabilityPersistenceMapper {

    @Override
    public AvailabilityEntity toEntity(Availability availability) {
        if ( availability == null ) {
            return null;
        }

        AvailabilityEntity.AvailabilityEntityBuilder availabilityEntity = AvailabilityEntity.builder();

        availabilityEntity.id( availability.getId() );
        availabilityEntity.tenantId( availability.getTenantId() );
        availabilityEntity.employeeId( availability.getEmployeeId() );
        availabilityEntity.dayOfWeek( mapDayOfWeek( availability.getDayOfWeek() ) );
        availabilityEntity.startTime( availability.getStartTime() );
        availabilityEntity.endTime( availability.getEndTime() );
        availabilityEntity.active( availability.isActive() );
        availabilityEntity.branchId( availability.getBranchId() );

        return availabilityEntity.build();
    }

    @Override
    public Availability toDomain(AvailabilityEntity entity) {
        if ( entity == null ) {
            return null;
        }

        Availability.AvailabilityBuilder availability = Availability.builder();

        availability.id( entity.getId() );
        availability.tenantId( entity.getTenantId() );
        availability.employeeId( entity.getEmployeeId() );
        availability.dayOfWeek( mapDayOfWeek( entity.getDayOfWeek() ) );
        availability.startTime( entity.getStartTime() );
        availability.endTime( entity.getEndTime() );
        availability.active( entity.isActive() );
        availability.branchId( entity.getBranchId() );

        return availability.build();
    }
}
