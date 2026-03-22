package com.appointment.infrastructure.adapters.out.persistence.repository;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import com.appointment.infrastructure.adapters.out.persistence.entity.AppointmentAuditEntity;

public interface AppointmentAuditJpaRepository extends JpaRepository<AppointmentAuditEntity, UUID> {
}
