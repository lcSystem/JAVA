package com.allianceever.projectERP.service.implementation;

import com.allianceever.projectERP.exception.ResourceNotFoundException;
import com.allianceever.projectERP.model.dto.LeavesDto;
import com.allianceever.projectERP.model.entity.LeaveType;
import com.allianceever.projectERP.model.entity.Leaves;
import com.allianceever.projectERP.repository.LeavesRepo;
import com.allianceever.projectERP.service.LeavesService;
import lombok.AllArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
@SuppressWarnings("null")
public class LeavesServiceImpl implements LeavesService {

    private LeavesRepo leavesRepo;
    private ModelMapper mapper;

    @Override
    public LeavesDto getByLeavesID(Long leavesID) {
        Leaves leaves = leavesRepo.findById(leavesID).orElseThrow(
                () -> new ResourceNotFoundException("Leaves does not exist with the given ID: " + leavesID));
        return mapper.map(leaves, LeavesDto.class);
    }

    @Override
    public LeavesDto create(LeavesDto leavesDto) {
        // convert DTO to entity
        Leaves leaves = mapper.map(leavesDto, Leaves.class);
        Leaves newLeave = leavesRepo.save(leaves);

        // convert entity to DTO
        return mapper.map(newLeave, LeavesDto.class);
    }

    @Override
    public LeavesDto update(Long leavesID, LeavesDto leavesDto) {
        Leaves existingLeaves = leavesRepo.findById(leavesID).orElseThrow(
                () -> new ResourceNotFoundException("Leaves does not exist with the given ID: " + leavesID));

        // Update fields
        existingLeaves.setLeaveReason(leavesDto.getLeaveReason());
        existingLeaves.setStartDate(leavesDto.getStartDate());
        existingLeaves.setEndDate(leavesDto.getEndDate());
        existingLeaves.setStatus(leavesDto.getStatus());
        existingLeaves.setNumberOfDays(leavesDto.getNumberOfDays());

        if (leavesDto.getLeaveType() != null) {
            existingLeaves.setLeaveType(mapper.map(leavesDto.getLeaveType(), LeaveType.class));
        }

        Leaves updatedLeaves = leavesRepo.save(existingLeaves);
        return mapper.map(updatedLeaves, LeavesDto.class);
    }

    @Override
    public List<LeavesDto> getAllLeavesOrderedByDate() {
        List<Leaves> leavesList = leavesRepo.findAllOrderByDate();

        return leavesList.stream()
                .map(leaves -> mapper.map(leaves, LeavesDto.class))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long leavesID) {
        if (!leavesRepo.existsById(leavesID)) {
            throw new ResourceNotFoundException("Leaves is not exist with given ID: " + leavesID);
        }
        leavesRepo.deleteById(leavesID);
    }

    @Override
    public List<LeavesDto> getAllLeavesByUsernameOrderedByDate(String username) {
        List<Leaves> leavesList = leavesRepo.getAllLeavesByUsernameOrderedByDate(username);

        return leavesList.stream()
                .map(leaves -> mapper.map(leaves, LeavesDto.class))
                .collect(Collectors.toList());
    }
}
