package com.appointment.infrastructure.adapters.out.persistence.mapper;

import com.appointment.domain.model.Appointment;
import com.appointment.domain.model.AppointmentStatus;
import com.appointment.domain.model.AppointmentType;
import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentEntity;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-03-22T00:02:12-0500",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 21.0.10 (Ubuntu)"
)
@Component
public class AppointmentPersistenceMapperImpl implements AppointmentPersistenceMapper {

    @Override
    public AppointmentEntity toEntity(Appointment appointment) {
        if ( appointment == null ) {
            return null;
        }

        AppointmentEntity.AppointmentEntityBuilder appointmentEntity = AppointmentEntity.builder();

        appointmentEntity.id( appointment.getId() );
        appointmentEntity.tenantId( appointment.getTenantId() );
        appointmentEntity.title( appointment.getTitle() );
        appointmentEntity.customerId( appointment.getCustomerId() );
        appointmentEntity.employeeId( appointment.getEmployeeId() );
        appointmentEntity.branchId( appointment.getBranchId() );
        appointmentEntity.startTime( appointment.getStartTime() );
        appointmentEntity.endTime( appointment.getEndTime() );
        if ( appointment.getStatus() != null ) {
            appointmentEntity.status( appointment.getStatus().name() );
        }
        if ( appointment.getType() != null ) {
            appointmentEntity.type( appointment.getType().name() );
        }
        appointmentEntity.notes( appointment.getNotes() );
        appointmentEntity.createdAt( appointment.getCreatedAt() );
        appointmentEntity.updatedAt( appointment.getUpdatedAt() );
        appointmentEntity.createdBy( appointment.getCreatedBy() );
        appointmentEntity.timezone( appointment.getTimezone() );
        appointmentEntity.duration( appointment.getDuration() );

        return appointmentEntity.build();
    }

    @Override
    public Appointment toDomain(AppointmentEntity entity) {
        if ( entity == null ) {
            return null;
        }

        Appointment.AppointmentBuilder appointment = Appointment.builder();

        appointment.id( entity.getId() );
        appointment.tenantId( entity.getTenantId() );
        appointment.title( entity.getTitle() );
        appointment.customerId( entity.getCustomerId() );
        appointment.employeeId( entity.getEmployeeId() );
        appointment.branchId( entity.getBranchId() );
        appointment.startTime( entity.getStartTime() );
        appointment.endTime( entity.getEndTime() );
        if ( entity.getStatus() != null ) {
            appointment.status( Enum.valueOf( AppointmentStatus.class, entity.getStatus() ) );
        }
        if ( entity.getType() != null ) {
            appointment.type( Enum.valueOf( AppointmentType.class, entity.getType() ) );
        }
        appointment.notes( entity.getNotes() );
        appointment.createdAt( entity.getCreatedAt() );
        appointment.updatedAt( entity.getUpdatedAt() );
        appointment.createdBy( entity.getCreatedBy() );
        appointment.timezone( entity.getTimezone() );
        appointment.duration( entity.getDuration() );

        return appointment.build();
    }
}
