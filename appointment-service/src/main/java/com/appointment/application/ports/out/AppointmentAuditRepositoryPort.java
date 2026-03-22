package com.appointment.application.ports.out;

import com.appointment.domain.model.AppointmentAudit;

public interface AppointmentAuditRepositoryPort {
    void save(AppointmentAudit audit);
}
