package com.allianceever.projectERP.service;

import com.allianceever.projectERP.model.dto.LeaveTypeDto;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface LeaveTypeService {
    LeaveTypeDto getById(Long id);

    LeaveTypeDto getByLeaveName(String leaveName);

    LeaveTypeDto create(LeaveTypeDto leaveTypeDto);

    LeaveTypeDto update(Long id, LeaveTypeDto leaveTypeDto);

    List<LeaveTypeDto> getAllLeaveType();

    List<LeaveTypeDto> getAllLeaveTypeByUsername(String username);

    void delete(Long id);
}
