package com.appointment.infrastructure.adapters.in.web;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.Authentication;

import com.appointment.application.ports.in.CancelAppointmentUseCase;
import com.appointment.application.ports.in.GetAvailabilityUseCase;
import com.appointment.application.ports.in.RescheduleAppointmentCommand;
import com.appointment.application.ports.in.RescheduleAppointmentUseCase;
import com.appointment.application.ports.in.ScheduleAppointmentCommand;
import com.appointment.application.ports.in.ScheduleAppointmentUseCase;
import com.appointment.application.ports.out.CustomerServicePort;
import com.appointment.domain.model.Appointment;
import com.appointment.domain.model.Availability;
import com.appointment.infrastructure.adapters.in.web.dto.AppointmentResponse;
import com.appointment.infrastructure.adapters.in.web.dto.RescheduleAppointmentRequest;
import com.appointment.infrastructure.adapters.in.web.dto.ScheduleAppointmentRequest;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/appointments")
@RequiredArgsConstructor
public class AppointmentController {

    private final ScheduleAppointmentUseCase scheduleUseCase;
    private final CancelAppointmentUseCase cancelUseCase;
    private final RescheduleAppointmentUseCase rescheduleUseCase;
    private final GetAvailabilityUseCase availabilityUseCase;
    private final CustomerServicePort customerServicePort;

    @PostMapping
    public ResponseEntity<AppointmentResponse> schedule(@Valid @RequestBody ScheduleAppointmentRequest request,
            Authentication auth) {

        ScheduleAppointmentCommand command = ScheduleAppointmentCommand.builder()
                .tenantId(request.getTenantId())
                .title(request.getTitle())
                .customerId(request.getCustomerId())
                .employeeId(request.getEmployeeId())
                .branchId(request.getBranchId())
                .startTime(request.getStartTime())
                .endTime(request.getEndTime())
                .type(request.getType())
                .notes(request.getNotes())
                .createdBy(auth != null ? auth.getName() : "system")
                .build();

        Appointment appointment = scheduleUseCase.schedule(command);

        return new ResponseEntity<>(mapToResponse(appointment), HttpStatus.CREATED);
    }

    @PostMapping("/{id}/cancel")
    public ResponseEntity<AppointmentResponse> cancel(@PathVariable("id") UUID id) {
        Appointment appointment = cancelUseCase.cancel(id);
        return ResponseEntity.ok(mapToResponse(appointment));
    }

    @PostMapping("/{id}/reschedule")
    public ResponseEntity<AppointmentResponse> reschedule(@PathVariable("id") UUID id,
            @Valid @RequestBody RescheduleAppointmentRequest request,
            Authentication auth) {
        RescheduleAppointmentCommand command = RescheduleAppointmentCommand.builder()
                .appointmentId(id)
                .tenantId(request.getTenantId())
                .newStartTime(request.getNewStartTime())
                .newEndTime(request.getNewEndTime())
                .notes(request.getNotes())
                .createdBy(auth != null ? auth.getName() : "system")
                .build();

        Appointment appointment = rescheduleUseCase.reschedule(command);
        return ResponseEntity.ok(mapToResponse(appointment));
    }

    @GetMapping("/availability/employee/{employeeId}")
    public ResponseEntity<List<Availability>> getAvailability(@PathVariable("employeeId") UUID employeeId,
            @RequestParam(name = "branchId", required = false) UUID branchId) {
        return ResponseEntity.ok(availabilityUseCase.getEmployeeAvailability(employeeId, branchId));
    }

    @GetMapping("/employee/{employeeId}")
    public ResponseEntity<List<AppointmentResponse>> getAppointmentsByEmployee(
            @PathVariable("employeeId") UUID employeeId,
            @RequestParam("start") @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE_TIME) java.time.LocalDateTime start,
            @RequestParam("end") @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE_TIME) java.time.LocalDateTime end) {

        List<Appointment> appointments = availabilityUseCase.getEmployeeAppointments(employeeId, start, end);
        List<AppointmentResponse> response = appointments.stream().map(this::mapToResponse).toList();

        return ResponseEntity.ok(response);
    }

    private AppointmentResponse mapToResponse(Appointment appointment) {
        String customerName = null;
        try {
            customerName = customerServicePort.getCustomerName(appointment.getCustomerId());
        } catch (Exception e) {
            // Fallback silently
        }

        return AppointmentResponse.builder()
                .id(appointment.getId())
                .title(appointment.getTitle())
                .customerId(appointment.getCustomerId())
                .customerName(customerName != null ? customerName : "Cliente")
                .employeeId(appointment.getEmployeeId())
                .branchId(appointment.getBranchId())
                .startTime(appointment.getStartTime())
                .endTime(appointment.getEndTime())
                .status(appointment.getStatus().name())
                .type(appointment.getType().name())
                .notes(appointment.getNotes())
                .build();
    }
}
