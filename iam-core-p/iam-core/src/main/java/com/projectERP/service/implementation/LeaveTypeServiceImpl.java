package com.allianceever.projectERP.service.implementation;

import com.allianceever.projectERP.exception.ResourceNotFoundException;
import com.allianceever.projectERP.model.dto.LeaveTypeDto;
import com.allianceever.projectERP.model.entity.LeaveType;
import com.allianceever.projectERP.repository.LeaveTypeRepo;
import com.allianceever.projectERP.service.LeaveTypeService;
import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
@SuppressWarnings("null")
public class LeaveTypeServiceImpl implements LeaveTypeService {

    private LeaveTypeRepo leaveTypeRepo;
    private ModelMapper mapper;

    @Override
    public LeaveTypeDto getById(Long id) {
        LeaveType leaveType = leaveTypeRepo.findById(id).orElseThrow(
                () -> new ResourceNotFoundException("Leave type does not exist with the given ID: " + id));
        return mapper.map(leaveType, LeaveTypeDto.class);
    }

    @Override
    public LeaveTypeDto getByLeaveName(String leaveName) {
        LeaveType leaveType = leaveTypeRepo.findByLeaveName(leaveName);
        if (leaveType == null) {
            throw new ResourceNotFoundException("Leave type does not exist with the given name: " + leaveName);
        }
        return mapper.map(leaveType, LeaveTypeDto.class);
    }

    @Override
    public LeaveTypeDto create(LeaveTypeDto leaveTypeDto) {
        LeaveType leaveType = mapper.map(leaveTypeDto, LeaveType.class);
        LeaveType newLeaveType = leaveTypeRepo.save(leaveType);
        return mapper.map(newLeaveType, LeaveTypeDto.class);
    }

    @Override
    public LeaveTypeDto update(Long id, LeaveTypeDto leaveTypeDto) {
        LeaveType existingLeaveType = leaveTypeRepo.findById(id).orElseThrow(
                () -> new ResourceNotFoundException("Leave type does not exist with the given ID: " + id));

        existingLeaveType.setLeaveStatus(leaveTypeDto.getLeaveStatus());
        existingLeaveType.setDays(leaveTypeDto.getDays());
        existingLeaveType.setLeaveName(leaveTypeDto.getLeaveName());

        LeaveType updatedLeaveType = leaveTypeRepo.save(existingLeaveType);
        return mapper.map(updatedLeaveType, LeaveTypeDto.class);
    }

    @Override
    public List<LeaveTypeDto> getAllLeaveType() {
        List<LeaveType> leaveTypes = leaveTypeRepo.findAll();
        return leaveTypes.stream()
                .map(leaveType -> mapper.map(leaveType, LeaveTypeDto.class))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (!leaveTypeRepo.existsById(id)) {
            throw new ResourceNotFoundException("Leave type does not exist with the given ID: " + id);
        }
        leaveTypeRepo.deleteById(id);
    }

    @Override
    public List<LeaveTypeDto> getAllLeaveTypeByUsername(String username) {
        List<LeaveType> leaveTypes = leaveTypeRepo.getAllLeaveTypeByUsername(username);
        return leaveTypes.stream()
                .map(leaveType -> mapper.map(leaveType, LeaveTypeDto.class))
                .collect(Collectors.toList());
    }
}
