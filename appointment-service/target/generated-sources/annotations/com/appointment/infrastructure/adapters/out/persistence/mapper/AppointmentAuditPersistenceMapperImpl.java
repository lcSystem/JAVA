package com.appointment.infrastructure.adapters.out.persistence.mapper;

import com.appointment.domain.model.AppointmentAudit;
import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentAuditEntity;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-03-22T00:02:12-0500",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 21.0.10 (Ubuntu)"
)
@Component
public class AppointmentAuditPersistenceMapperImpl implements AppointmentAuditPersistenceMapper {

    @Override
    public AppointmentAuditEntity toEntity(AppointmentAudit audit) {
        if ( audit == null ) {
            return null;
        }

        AppointmentAuditEntity.AppointmentAuditEntityBuilder appointmentAuditEntity = AppointmentAuditEntity.builder();

        appointmentAuditEntity.id( audit.getId() );
        appointmentAuditEntity.tenantId( audit.getTenantId() );
        appointmentAuditEntity.appointmentId( audit.getAppointmentId() );
        appointmentAuditEntity.action( audit.getAction() );
        appointmentAuditEntity.oldStatus( audit.getOldStatus() );
        appointmentAuditEntity.newStatus( audit.getNewStatus() );
        appointmentAuditEntity.changedAt( audit.getChangedAt() );
        appointmentAuditEntity.changedBy( audit.getChangedBy() );

        return appointmentAuditEntity.build();
    }

    @Override
    public AppointmentAudit toDomain(AppointmentAuditEntity entity) {
        if ( entity == null ) {
            return null;
        }

        AppointmentAudit.AppointmentAuditBuilder appointmentAudit = AppointmentAudit.builder();

        appointmentAudit.id( entity.getId() );
        appointmentAudit.tenantId( entity.getTenantId() );
        appointmentAudit.appointmentId( entity.getAppointmentId() );
        appointmentAudit.action( entity.getAction() );
        appointmentAudit.oldStatus( entity.getOldStatus() );
        appointmentAudit.newStatus( entity.getNewStatus() );
        appointmentAudit.changedAt( entity.getChangedAt() );
        appointmentAudit.changedBy( entity.getChangedBy() );

        return appointmentAudit.build();
    }
}
