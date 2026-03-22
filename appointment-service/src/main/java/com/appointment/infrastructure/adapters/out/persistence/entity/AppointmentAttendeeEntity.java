package com.appointment.infrastructure.adapters.out.persistence.entity;

import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "appointment_attendees")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentAttendeeEntity {
    @Id
    private UUID id;

    @ManyToOne(fetch = jakarta.persistence.FetchType.LAZY)
    @JoinColumn(name = "appointment_id", referencedColumnName = "id")
    private AppointmentEntity appointment;

    private UUID userId;
    private String status;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
