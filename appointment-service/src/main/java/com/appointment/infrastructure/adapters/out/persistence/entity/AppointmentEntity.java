package com.appointment.infrastructure.adapters.out.persistence.entity;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "appointments")
@SQLDelete(sql = "UPDATE appointment.appointments SET is_deleted = true WHERE id = ?")
@Where(clause = "is_deleted = false")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentEntity {
    @Id
    private UUID id;
    private UUID tenantId;

    private String title;
    private String customerId;
    private UUID employeeId;
    private UUID branchId;

    private LocalDateTime startTime;
    private LocalDateTime endTime;

    private String status;
    private String type;
    private String notes;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String createdBy;

    private boolean isDeleted;
    private String timezone;
    private Integer duration;

    @OneToMany(mappedBy = "appointment", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AppointmentAttendeeEntity> attendees;
}
