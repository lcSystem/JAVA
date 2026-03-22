package com.appointment.infrastructure.adapters.out.persistence.entity;

import java.time.LocalTime;
import java.util.UUID;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "availability")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AvailabilityEntity {
    @Id
    private UUID id;

    private UUID tenantId;
    private UUID employeeId;
    private Integer dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;
    @jakarta.persistence.Column(name = "is_active")
    private boolean active;
    private UUID branchId;
}
