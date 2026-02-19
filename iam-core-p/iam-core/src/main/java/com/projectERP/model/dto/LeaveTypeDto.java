package com.allianceever.projectERP.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LeaveTypeDto {
    private Long leaveTypeId;

    private String username;

    private String leaveName;

    private Integer days;

    private String leaveStatus;
}
