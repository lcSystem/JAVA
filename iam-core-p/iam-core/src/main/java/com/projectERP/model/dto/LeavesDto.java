package com.allianceever.projectERP.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LeavesDto {

    private Long LeavesID;

    private String username;

    private String EmployeeName;

    private LeaveTypeDto leaveType;

    private Integer NumberOfDays;

    private LocalDate StartDate;

    private LocalDate EndDate;

    private String LeaveReason;

    private String ApprovedBy;

    private String Status;
}
