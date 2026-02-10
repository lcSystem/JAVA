package com.allianceever.projectERP.controller;

import com.allianceever.projectERP.model.dto.LeaveTypeDto;
import com.allianceever.projectERP.service.LeaveTypeService;
import lombok.AllArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.allianceever.projectERP.controller.EmployeeController.getStrings;
import static org.springframework.http.HttpStatus.CREATED;

@RestController
@RequestMapping("/api/leaveType")
@ComponentScan(basePackages = "com.allianceever.projectERP")
@AllArgsConstructor
public class LeaveTypeController {

    private LeaveTypeService leaveTypeService;

    @GetMapping("/all")
    public ResponseEntity<List<LeaveTypeDto>> getAllLeaveTypes() {
        return ResponseEntity.ok(leaveTypeService.getAllLeaveType());
    }

    @PostMapping("/create")
    public ResponseEntity<LeaveTypeDto> createLeaveType(@ModelAttribute() LeaveTypeDto leaveTypeDto,
            @AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        String leaveName = leaveTypeDto.getLeaveName() + "(" + username + ")";

        leaveTypeDto.setUsername(username);
        leaveTypeDto.setLeaveName(leaveName);
        LeaveTypeDto createdLeaveType = leaveTypeService.create(leaveTypeDto);
        return new ResponseEntity<>(createdLeaveType, CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<LeaveTypeDto> getLeaveTypeById(@PathVariable("id") Long id,
            @AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        LeaveTypeDto leaveTypeDto = leaveTypeService.getById(id);
        if (leaveTypeDto != null) {
            if (leaveTypeDto.getUsername().equals(username) || role.equals("ADMIN") || role.equals("Human_Capital")) {
                return ResponseEntity.ok(leaveTypeDto);
            }
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/name/{leaveTypeName}")
    public ResponseEntity<LeaveTypeDto> getLeaveTypeByName(@PathVariable("leaveTypeName") String leaveTypeName,
            @AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        LeaveTypeDto leaveTypeDto = leaveTypeService.getByLeaveName(leaveTypeName);
        if (leaveTypeDto != null) {
            if (leaveTypeDto.getUsername().equals(username) || role.equals("ADMIN") || role.equals("Human_Capital")) {
                return ResponseEntity.ok(leaveTypeDto);
            }
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping("/updateLeaveType")
    @SuppressWarnings("null")
    public ResponseEntity<LeaveTypeDto> updateLeaveType(@ModelAttribute LeaveTypeDto leaveTypeDto) {
        Long leaveTypeId = leaveTypeDto.getLeaveTypeId();
        if (leaveTypeId == null) {
            return ResponseEntity.badRequest().build();
        }
        LeaveTypeDto existingLeaveType = leaveTypeService.getById(leaveTypeId);
        if (existingLeaveType == null) {
            return ResponseEntity.notFound().build();
        }

        BeanUtils.copyProperties(leaveTypeDto, existingLeaveType, getNullPropertyNames(leaveTypeDto));

        LeaveTypeDto updatedLeaveType = leaveTypeService.update(leaveTypeId, existingLeaveType);
        return ResponseEntity.ok(updatedLeaveType);
    }

    @PostMapping("/delete/{id}")
    public ResponseEntity<String> deleteLeaveType(@PathVariable("id") Long id, @AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        LeaveTypeDto leaveTypeDto = leaveTypeService.getById(id);

        if (leaveTypeDto != null) {
            if (leaveTypeDto.getUsername().equals(username) || role.equals("ADMIN") || role.equals("Human_Capital")) {
                leaveTypeService.delete(id);
                return ResponseEntity.ok("LeaveType deleted successfully!");
            }
        }
        return ResponseEntity.notFound().build();
    }

    public static String[] getNullPropertyNames(Object source) {
        return getStrings(source);
    }
}
