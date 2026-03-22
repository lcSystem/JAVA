package com.appointment.domain.model;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Availability {
    private UUID id;
    private UUID tenantId;
    private UUID employeeId;
    private DayOfWeek dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;
    private boolean active;
    private UUID branchId;

    public boolean isWithinSchedule(LocalTime checkStartTime, LocalTime checkEndTime) {
        if (!active)
            return false;
        return !checkStartTime.isBefore(this.startTime) && !checkEndTime.isAfter(this.endTime);
    }
}
