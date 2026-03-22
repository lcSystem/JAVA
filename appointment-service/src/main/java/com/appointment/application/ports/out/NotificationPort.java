package com.appointment.application.ports.out;

import com.appointment.domain.model.Appointment;

public interface NotificationPort {
    void sendAppointmentConfirmation(Appointment appointment);

    void sendAppointmentCancellation(Appointment appointment);
}
