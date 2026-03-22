package com.appointment.application.usecase;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.appointment.application.ports.in.ScheduleAppointmentCommand;
import com.appointment.application.ports.out.AppointmentRepositoryPort;
import com.appointment.application.ports.out.NotificationPort;
import com.appointment.domain.exception.TimeSlotTakenException;
import com.appointment.domain.model.Appointment;
import com.appointment.domain.model.AppointmentStatus;
import com.appointment.domain.model.AppointmentType;

class AppointmentManagementServiceTest {

    @Mock
    private AppointmentRepositoryPort appointmentRepository;

    @Mock
    private NotificationPort notificationPort;

    @InjectMocks
    private AppointmentManagementService appointmentManagementService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void schedule_WhenValidCommand_ShouldSaveAndNotify() {
        // Arrange
        String title = "Test Meeting";
        UUID employeeId = UUID.randomUUID();

        ScheduleAppointmentCommand cmd = ScheduleAppointmentCommand.builder()
                .title(title)
                .employeeId(employeeId)
                .startTime(LocalDateTime.now().plusDays(1))
                .endTime(LocalDateTime.now().plusDays(1).plusHours(1))
                .type(AppointmentType.VIRTUAL)
                .build();

        when(appointmentRepository.existsOverlapping(eq(employeeId), any(), any())).thenReturn(false);
        when(appointmentRepository.save(any(Appointment.class))).thenAnswer(i -> i.getArguments()[0]);

        // Act
        Appointment result = appointmentManagementService.schedule(cmd);

        // Assert
        assertNotNull(result);
        assertEquals(AppointmentStatus.PENDING, result.getStatus());
        verify(appointmentRepository).save(any(Appointment.class));
        verify(notificationPort).sendAppointmentConfirmation(any(Appointment.class));
    }

    @Test
    void schedule_WhenSlotTaken_ShouldThrowException() {
        String title = "Test Meeting";
        UUID employeeId = UUID.randomUUID();
        ScheduleAppointmentCommand cmd = ScheduleAppointmentCommand.builder()
                .title(title)
                .employeeId(employeeId)
                .startTime(LocalDateTime.now().plusDays(1))
                .endTime(LocalDateTime.now().plusDays(1).plusHours(1))
                .build();

        when(appointmentRepository.existsOverlapping(eq(employeeId), any(), any())).thenReturn(true);

        assertThrows(TimeSlotTakenException.class, () -> appointmentManagementService.schedule(cmd));
    }

    @Test
    void cancel_WhenAppointmentExists_ShouldCancelAndNotify() {
        UUID appId = UUID.randomUUID();
        Appointment appointment = new Appointment();
        appointment.setId(appId);
        appointment.setStatus(AppointmentStatus.PENDING);
        appointment.setTitle("Test Meeting");

        when(appointmentRepository.findById(appId)).thenReturn(Optional.of(appointment));
        when(appointmentRepository.save(any(Appointment.class))).thenAnswer(i -> i.getArguments()[0]);

        Appointment cancelled = appointmentManagementService.cancel(appId);

        assertEquals(AppointmentStatus.CANCELLED, cancelled.getStatus());
        verify(notificationPort).sendAppointmentCancellation(appointment);
    }
}
