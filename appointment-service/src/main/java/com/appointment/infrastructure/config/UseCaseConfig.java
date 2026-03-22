package com.appointment.infrastructure.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.appointment.application.ports.out.AppointmentAuditRepositoryPort;
import com.appointment.application.ports.out.AppointmentRepositoryPort;
import com.appointment.application.ports.out.AvailabilityRepositoryPort;
import com.appointment.application.ports.out.NotificationPort;
import com.appointment.application.usecase.AppointmentManagementService;

@Configuration
public class UseCaseConfig {

    @Bean
    public AppointmentManagementService appointmentManagementService(
            AppointmentRepositoryPort appointmentRepository,
            AvailabilityRepositoryPort availabilityRepository,
            AppointmentAuditRepositoryPort auditRepository,
            NotificationPort notificationPort) {
        return new AppointmentManagementService(appointmentRepository, availabilityRepository, auditRepository,
                notificationPort);
    }
}
