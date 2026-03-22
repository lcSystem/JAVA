package com.appointment.infrastructure.adapters.out.persistence.mapper;

import com.appointment.domain.model.Appointment;
import com.appointment.domain.model.AppointmentAttendee;
import com.appointment.domain.model.AppointmentStatus;
import com.appointment.domain.model.AppointmentType;
import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentAttendeeEntity;
import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentEntity;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-03-22T00:46:18-0500",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.45.0.v20260128-0750, environment: Java 21.0.9 (Eclipse Adoptium)"
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
        appointmentEntity.attendees( appointmentAttendeeListToAppointmentAttendeeEntityList( appointment.getAttendees() ) );

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
        appointment.attendees( appointmentAttendeeEntityListToAppointmentAttendeeList( entity.getAttendees() ) );

        return appointment.build();
    }

    protected AppointmentAttendeeEntity appointmentAttendeeToAppointmentAttendeeEntity(AppointmentAttendee appointmentAttendee) {
        if ( appointmentAttendee == null ) {
            return null;
        }

        AppointmentAttendeeEntity.AppointmentAttendeeEntityBuilder appointmentAttendeeEntity = AppointmentAttendeeEntity.builder();

        appointmentAttendeeEntity.id( appointmentAttendee.getId() );
        appointmentAttendeeEntity.userId( appointmentAttendee.getUserId() );
        if ( appointmentAttendee.getStatus() != null ) {
            appointmentAttendeeEntity.status( appointmentAttendee.getStatus().name() );
        }

        return appointmentAttendeeEntity.build();
    }

    protected List<AppointmentAttendeeEntity> appointmentAttendeeListToAppointmentAttendeeEntityList(List<AppointmentAttendee> list) {
        if ( list == null ) {
            return null;
        }

        List<AppointmentAttendeeEntity> list1 = new ArrayList<AppointmentAttendeeEntity>( list.size() );
        for ( AppointmentAttendee appointmentAttendee : list ) {
            list1.add( appointmentAttendeeToAppointmentAttendeeEntity( appointmentAttendee ) );
        }

        return list1;
    }

    protected AppointmentAttendee appointmentAttendeeEntityToAppointmentAttendee(AppointmentAttendeeEntity appointmentAttendeeEntity) {
        if ( appointmentAttendeeEntity == null ) {
            return null;
        }

        AppointmentAttendee.AppointmentAttendeeBuilder appointmentAttendee = AppointmentAttendee.builder();

        appointmentAttendee.id( appointmentAttendeeEntity.getId() );
        appointmentAttendee.userId( appointmentAttendeeEntity.getUserId() );
        if ( appointmentAttendeeEntity.getStatus() != null ) {
            appointmentAttendee.status( Enum.valueOf( AppointmentAttendee.AttendeeStatus.class, appointmentAttendeeEntity.getStatus() ) );
        }

        return appointmentAttendee.build();
    }

    protected List<AppointmentAttendee> appointmentAttendeeEntityListToAppointmentAttendeeList(List<AppointmentAttendeeEntity> list) {
        if ( list == null ) {
            return null;
        }

        List<AppointmentAttendee> list1 = new ArrayList<AppointmentAttendee>( list.size() );
        for ( AppointmentAttendeeEntity appointmentAttendeeEntity : list ) {
            list1.add( appointmentAttendeeEntityToAppointmentAttendee( appointmentAttendeeEntity ) );
        }

        return list1;
    }
}
