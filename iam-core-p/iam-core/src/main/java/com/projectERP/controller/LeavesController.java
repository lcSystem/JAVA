package com.projectERP.controller;

import com.projectERP.model.dto.EmployeeDto;
import com.projectERP.model.dto.LeavesDto;
import com.projectERP.service.EmployeeService;
import com.projectERP.service.LeavesService;
import lombok.AllArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.projectERP.controller.EmployeeController.getStrings;

@RestController
@RequestMapping("/leaves")
@ComponentScan(basePackages = "com.projectERP")
@AllArgsConstructor
public class LeavesController {
    private LeavesService leavesService;
    private EmployeeService employeeService;

    @GetMapping("/all")
    public ResponseEntity<List<LeavesDto>> getAllLeaves() {
        return ResponseEntity.ok(leavesService.getAllLeavesOrderedByDate());
    }

    @PostMapping("/create")
    public ResponseEntity<LeavesDto> createLeaves(@ModelAttribute() LeavesDto leavesDto,
            @AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        if (role.equals("ADMIN")) {
            leavesDto.setUsername(username);
            leavesDto.setEmployeeName(username);
        } else {
            EmployeeDto employeeDto = employeeService.getByUsername(username);
            String employeeName = (employeeDto != null) ? employeeDto.getFirst_Name() + " " + employeeDto.getLast_Name()
                    : username;
            leavesDto.setUsername(username);
            leavesDto.setEmployeeName(employeeName);
        }

        LeavesDto createdLeave = leavesService.create(leavesDto);
        return new ResponseEntity<>(createdLeave, org.springframework.http.HttpStatus.CREATED);
    }

    @GetMapping("/{LeavesID}")
    public ResponseEntity<LeavesDto> getLeavesByLeavesID(@PathVariable("LeavesID") Long LeavesID,
            @AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        LeavesDto leavesDto = leavesService.getByLeavesID(LeavesID);
        if (leavesDto != null) {
            if (leavesDto.getUsername().equals(username) || role.equals("ADMIN") || role.equals("Human_Capital")) {
                return ResponseEntity.ok(leavesDto);
            }
        }
        return ResponseEntity.notFound().build();
    }

    @PutMapping("/updateLeaves")
    @SuppressWarnings("null")
    public ResponseEntity<LeavesDto> updateLeaves(@ModelAttribute LeavesDto leavesDto,
            @AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        Long LeavesID = leavesDto.getLeavesID();
        if (LeavesID == null) {
            return ResponseEntity.badRequest().build();
        }

        LeavesDto existingLeaves = leavesService.getByLeavesID(LeavesID);
        if (existingLeaves == null) {
            return ResponseEntity.notFound().build();
        }

        BeanUtils.copyProperties(leavesDto, existingLeaves, getNullPropertyNames(leavesDto));

        if (leavesDto.getStatus() != null) {
            if (role.equals("ADMIN") || role.equals("Human_Capital")) {
                String approvedBy;
                if (role.equals("Human_Capital")) {
                    EmployeeDto employeeDto = employeeService.getByUsername(username);
                    approvedBy = employeeDto.getFirst_Name() + " " + employeeDto.getLast_Name();
                } else {
                    approvedBy = "ADMIN";
                }
                existingLeaves.setApprovedBy(approvedBy);
            } else if (!existingLeaves.getUsername().equals(username)) {
                return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN).build();
            }
        } else if (!existingLeaves.getUsername().equals(username) && !role.equals("ADMIN")
                && !role.equals("Human_Capital")) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN).build();
        }

        LeavesDto updatedLeaves = leavesService.update(LeavesID, existingLeaves);
        return ResponseEntity.ok(updatedLeaves);
    }

    @DeleteMapping("/delete/{LeavesID}")
    public ResponseEntity<String> deleteLeaves(@PathVariable("LeavesID") Long LeavesID,
            @AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        LeavesDto leavesDto = leavesService.getByLeavesID(LeavesID);
        if (leavesDto == null) {
            return ResponseEntity.notFound().build();
        }

        if (leavesDto.getUsername().equals(username) || role.equals("ADMIN") || role.equals("Human_Capital")) {
            leavesService.delete(LeavesID);
            return ResponseEntity.ok("Leave deleted successfully!");
        }
        return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN).build();
    }

    @SuppressWarnings("null")
    public static String[] getNullPropertyNames(Object source) {
        return getStrings(source);
    }
}
