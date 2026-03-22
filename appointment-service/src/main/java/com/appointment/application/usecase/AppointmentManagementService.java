package com.appointment.application.usecase;

import java.time.LocalDateTime;
import java.util.UUID;

import com.appointment.application.ports.in.CancelAppointmentUseCase;
import com.appointment.application.ports.in.GetAvailabilityUseCase;
import com.appointment.application.ports.in.RescheduleAppointmentCommand;
import com.appointment.application.ports.in.RescheduleAppointmentUseCase;
import com.appointment.application.ports.in.ScheduleAppointmentCommand;
import com.appointment.application.ports.in.ScheduleAppointmentUseCase;
import com.appointment.application.ports.in.UpdateAppointmentCommand;
import com.appointment.application.ports.in.UpdateAppointmentUseCase;
import com.appointment.application.ports.in.RespondInvitationUseCase;
import com.appointment.application.ports.in.RespondInvitationCommand;
import com.appointment.application.ports.out.AppointmentAuditRepositoryPort;
import com.appointment.application.ports.out.AppointmentRepositoryPort;
import com.appointment.application.ports.out.AvailabilityRepositoryPort;
import com.appointment.application.ports.out.NotificationPort;
import com.appointment.domain.exception.TimeSlotTakenException;
import com.appointment.domain.model.Appointment;
import com.appointment.domain.model.AppointmentAudit;
import com.appointment.domain.model.AppointmentStatus;
import com.appointment.domain.model.Availability;
import com.appointment.domain.model.AppointmentAttendee;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

// Do not annotate with @Service here to keep it pure. We will configure it as a Spring Bean in infrastructure.
@RequiredArgsConstructor
@Transactional
public class AppointmentManagementService
                implements ScheduleAppointmentUseCase, CancelAppointmentUseCase, RescheduleAppointmentUseCase,
                UpdateAppointmentUseCase, GetAvailabilityUseCase, RespondInvitationUseCase {

        private final AppointmentRepositoryPort appointmentRepository;
        private final AvailabilityRepositoryPort availabilityRepository;
        private final AppointmentAuditRepositoryPort auditRepository;
        private final NotificationPort notificationPort;

        @Override
        public Appointment schedule(ScheduleAppointmentCommand command) {
                // 0. Base Validations (Enterprise Level)
                if (command.getStartTime().isBefore(LocalDateTime.now())) {
                        throw new IllegalArgumentException("Cannot schedule appointments in the past");
                }

                long durationMinutes = java.time.Duration.between(command.getStartTime(), command.getEndTime())
                                .toMinutes();
                if (durationMinutes <= 0) {
                        throw new IllegalArgumentException("Appointment duration must be positive");
                }

                // 1. Validate Time Slot mapping (avoid overlapping)
                boolean overlapping = appointmentRepository.existsOverlapping(
                                command.getEmployeeId(),
                                command.getStartTime(),
                                command.getEndTime());
                if (overlapping) {
                        throw new TimeSlotTakenException(
                                        "The time slot is already taken for employee " + command.getEmployeeId());
                }

                // 3. Create Appointment Entity
                Appointment appointment = Appointment.builder()
                                .id(UUID.randomUUID())
                                .tenantId(command.getTenantId())
                                .title(command.getTitle())
                                .customerId(command.getCustomerId())
                                .employeeId(command.getEmployeeId())
                                .branchId(command.getBranchId())
                                .startTime(command.getStartTime())
                                .endTime(command.getEndTime())
                                .duration((int) durationMinutes)
                                .status(AppointmentStatus.PENDING)
                                .type(command.getType())
                                .notes(command.getNotes())
                                .createdAt(LocalDateTime.now())
                                .updatedAt(LocalDateTime.now())
                                .createdBy(command.getCreatedBy())
                                .build();

                if (command.getAttendeeIds() != null) {
                        List<AppointmentAttendee> attendees = command.getAttendeeIds().stream()
                                        .map(id -> AppointmentAttendee.builder()
                                                        .id(UUID.randomUUID())
                                                        .userId(id)
                                                        .status(AppointmentAttendee.AttendeeStatus.PENDING)
                                                        .build())
                                        .collect(Collectors.toList());
                        appointment.setAttendees(attendees);
                }

                // 4. Save
                Appointment saved = appointmentRepository.save(appointment);

                // 5. Audit
                auditRepository.save(AppointmentAudit.builder()
                                .id(UUID.randomUUID())
                                .tenantId(saved.getTenantId())
                                .appointmentId(saved.getId())
                                .action("CREATE")
                                .newStatus(saved.getStatus().name())
                                .changedAt(LocalDateTime.now())
                                .changedBy(saved.getCreatedBy())
                                .build());

                // 6. Notify
                notificationPort.sendAppointmentConfirmation(saved);

                return saved;
        }

        @Override
        public Appointment cancel(UUID appointmentId) {
                Appointment appointment = appointmentRepository.findById(appointmentId)
                                .orElseThrow(() -> new IllegalArgumentException(
                                                "Appointment not found: " + appointmentId));

                String oldStatus = appointment.getStatus().name();
                appointment.cancel();

                Appointment saved = appointmentRepository.save(appointment);

                // Audit
                auditRepository.save(AppointmentAudit.builder()
                                .id(UUID.randomUUID())
                                .tenantId(saved.getTenantId())
                                .appointmentId(saved.getId())
                                .action("CANCEL")
                                .oldStatus(oldStatus)
                                .newStatus(saved.getStatus().name())
                                .changedAt(LocalDateTime.now())
                                .changedBy("system")
                                .build());

                notificationPort.sendAppointmentCancellation(saved);

                return saved;
        }

        @Override
        public Appointment reschedule(RescheduleAppointmentCommand command) {
                Appointment appointment = appointmentRepository.findById(command.getAppointmentId())
                                .orElseThrow(
                                                () -> new IllegalArgumentException("Appointment not found: "
                                                                + command.getAppointmentId()));

                // 0. Base Validations (Enterprise Level)
                if (command.getNewStartTime().isBefore(LocalDateTime.now())) {
                        throw new IllegalArgumentException("Cannot reschedule appointments to the past");
                }

                long durationMinutes = java.time.Duration.between(command.getNewStartTime(), command.getNewEndTime())
                                .toMinutes();
                if (durationMinutes <= 0) {
                        throw new IllegalArgumentException("Appointment duration must be positive");
                }

                // Validate new slot (exclude this appointment from overlap check)
                boolean overlapping = appointmentRepository.existsOverlappingExcluding(
                                appointment.getEmployeeId(),
                                command.getNewStartTime(),
                                command.getNewEndTime(),
                                appointment.getId());

                if (overlapping) {
                        throw new TimeSlotTakenException("The new time slot is already taken.");
                }

                String oldStatus = appointment.getStatus().name();
                appointment.setStartTime(command.getNewStartTime());
                appointment.setEndTime(command.getNewEndTime());
                appointment.setDuration((int) durationMinutes);
                appointment.setStatus(AppointmentStatus.RESCHEDULED);
                appointment.setNotes(command.getNotes());
                appointment.setUpdatedAt(LocalDateTime.now());

                Appointment saved = appointmentRepository.save(appointment);

                // Audit
                auditRepository.save(AppointmentAudit.builder()
                                .id(UUID.randomUUID())
                                .tenantId(saved.getTenantId())
                                .appointmentId(saved.getId())
                                .action("RESCHEDULE")
                                .oldStatus(oldStatus)
                                .newStatus(saved.getStatus().name())
                                .changedAt(LocalDateTime.now())
                                .changedBy(command.getCreatedBy())
                                .build());

                notificationPort.sendAppointmentConfirmation(saved);

                return saved;
        }

        @Override
        public Appointment update(UpdateAppointmentCommand command) {
                Appointment appointment = appointmentRepository.findById(command.getAppointmentId())
                                .orElseThrow(() -> new IllegalArgumentException("Appointment not found: "
                                                + command.getAppointmentId()));

                if (command.getStartTime().isBefore(LocalDateTime.now())
                                && !command.getStartTime().equals(appointment.getStartTime())) {
                        throw new IllegalArgumentException("Cannot schedule appointments in the past");
                }

                long durationMinutes = java.time.Duration.between(command.getStartTime(), command.getEndTime())
                                .toMinutes();
                if (durationMinutes <= 0) {
                        throw new IllegalArgumentException("Appointment duration must be positive");
                }

                boolean overlapping = appointmentRepository.existsOverlappingExcluding(
                                appointment.getEmployeeId(),
                                command.getStartTime(),
                                command.getEndTime(),
                                appointment.getId());

                if (overlapping) {
                        throw new TimeSlotTakenException("The new time slot is already taken.");
                }

                appointment.setTitle(command.getTitle());
                appointment.setCustomerId(command.getCustomerId());
                appointment.setStartTime(command.getStartTime());
                appointment.setEndTime(command.getEndTime());
                appointment.setDuration((int) durationMinutes);
                appointment.setType(command.getType());
                appointment.setNotes(command.getNotes());
                appointment.setUpdatedAt(LocalDateTime.now());

                if (command.getAttendeeIds() != null) {
                        List<AppointmentAttendee> attendees = command.getAttendeeIds().stream()
                                        .map(id -> AppointmentAttendee.builder()
                                                        .id(UUID.randomUUID())
                                                        .userId(id)
                                                        .status(AppointmentAttendee.AttendeeStatus.PENDING)
                                                        .build())
                                        .collect(Collectors.toList());
                        appointment.setAttendees(attendees);
                } else {
                        appointment.setAttendees(null);
                }

                Appointment saved = appointmentRepository.save(appointment);

                auditRepository.save(AppointmentAudit.builder()
                                .id(UUID.randomUUID())
                                .tenantId(saved.getTenantId())
                                .appointmentId(saved.getId())
                                .action("UPDATE")
                                .oldStatus(appointment.getStatus().name())
                                .newStatus(saved.getStatus().name())
                                .changedAt(LocalDateTime.now())
                                .changedBy(command.getUpdatedBy())
                                .build());

                return saved;
        }

        @Override
        public List<Availability> getEmployeeAvailability(UUID employeeId, UUID branchId) {
                return availabilityRepository.findByEmployeeId(employeeId);
        }

        @Override
        public List<Appointment> getEmployeeAppointments(UUID employeeId, LocalDateTime start, LocalDateTime end) {
                return appointmentRepository.findByEmployeeIdAndDateRange(employeeId, start, end);
        }

        @Override
        public Appointment respond(RespondInvitationCommand command) {
                Appointment appointment = appointmentRepository.findById(command.getAppointmentId())
                                .orElseThrow(() -> new IllegalArgumentException("Appointment not found: "
                                                + command.getAppointmentId()));

                boolean updated = false;
                if (appointment.getAttendees() != null) {
                        for (AppointmentAttendee attendee : appointment.getAttendees()) {
                                if (attendee.getUserId().equals(command.getUserId())) {
                                        attendee.setStatus(command.getStatus());
                                        updated = true;
                                        break;
                                }
                        }
                }

                if (!updated) {
                        throw new IllegalArgumentException("Attendee not found for this appointment.");
                }

                Appointment saved = appointmentRepository.save(appointment);

                // Re-notify optionally if status changed to ACCEPTED/REJECTED
                auditRepository.save(AppointmentAudit.builder()
                                .id(UUID.randomUUID())
                                .tenantId(saved.getTenantId())
                                .appointmentId(saved.getId())
                                .action(command.getStatus().name())
                                .oldStatus("PENDING")
                                .newStatus(command.getStatus().name())
                                .changedAt(LocalDateTime.now())
                                .changedBy(command.getUserId().toString())
                                .build());

                return saved;
        }
}
