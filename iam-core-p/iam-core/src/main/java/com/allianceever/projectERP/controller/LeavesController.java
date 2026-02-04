package com.allianceever.projectERP.controller;

import com.allianceever.projectERP.AuthenticatedBackend.utils.RSAKeyProperties;
import com.allianceever.projectERP.model.dto.EmployeeDto;
import com.allianceever.projectERP.model.dto.LeavesDto;
import com.allianceever.projectERP.service.EmployeeService;
import com.allianceever.projectERP.service.LeavesService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import lombok.AllArgsConstructor;
import org.springframework.beans.BeanUtils;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.allianceever.projectERP.controller.EmployeeController.getStrings;

@RestController
@RequestMapping("/leaves")
@ComponentScan(basePackages = "com.allianceever.projectERP")
@AllArgsConstructor
public class LeavesController {
    private LeavesService leavesService;
    private EmployeeService employeeService;
    private final RSAKeyProperties rsaKeyProperties;

    @GetMapping("/all")
    public ResponseEntity<List<LeavesDto>> getAllLeaves() {
        return ResponseEntity.ok(leavesService.getAllLeavesOrderedByDate());
    }

    @PostMapping("/create")
    public ResponseEntity<LeavesDto> createLeaves(@ModelAttribute() LeavesDto leavesDto,
            @AuthenticationPrincipal Jwt jwt) {
        // Retrieve username and role from the jwt
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        // Logic to set username and employeeName
        if (role.equals("ADMIN")) {
            leavesDto.setUsername(username);
            leavesDto.setEmployeeName(username);
        } else {
            EmployeeDto employeeDto = employeeService.getByUsername(username);
            // Default to username if employee not found, or handle error
            String employeeName = (employeeDto != null) ? employeeDto.getFirst_Name() + " " + employeeDto.getLast_Name()
                    : username;
            leavesDto.setUsername(username);
            leavesDto.setEmployeeName(employeeName);
        }

        LeavesDto createdLeave = leavesService.create(leavesDto);
        return new ResponseEntity<>(createdLeave, org.springframework.http.HttpStatus.CREATED);
    }

    @GetMapping("/{Leaves}")
    public ResponseEntity<LeavesDto> getLeavesByLeavesID(@PathVariable("Leaves") Integer LeavesID,
            @CookieValue(value = "jwtToken", defaultValue = "") String jwtToken) {
        String username = "";
        String role = "";
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(rsaKeyProperties.getPublicKey()) // Use the public key for verification
                    .build()
                    .parseClaimsJws(jwtToken)
                    .getBody();

            // Retrieve username and role from the jwt
            username = (String) claims.get("sub");
            role = (String) claims.get("roles");

        } catch (Exception e) {
            e.printStackTrace();
        }

        LeavesDto leavesDto = leavesService.getByLeavesID(LeavesID);
        if (leavesDto != null) {
            if (!role.equals("")) {
                if (leavesDto.getUsername().equals(username) || role.equals("ADMIN") || role.equals("Human_Capital")) {
                    return ResponseEntity.ok(leavesDto);
                } else {
                    return ResponseEntity.notFound().build();
                }
            } else {
                return ResponseEntity.notFound().build();
            }
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/updateLeaves")
    public ResponseEntity<LeavesDto> updateLeaves(@ModelAttribute LeavesDto leavesDto,
            @AuthenticationPrincipal Jwt jwt) {
        // Retrieve username and role from the jwt
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        Integer LeavesID = leavesDto.getLeavesID();
        LeavesDto existingLeaves = leavesService.getByLeavesID(LeavesID);
        if (existingLeaves == null) {
            return ResponseEntity.notFound().build();
        }
        BeanUtils.copyProperties(leavesDto, existingLeaves, getNullPropertyNames(leavesDto));

        if (leavesDto.getStatus() != null) {
            if (!leavesDto.equals("")) {
                if (role.equals("ADMIN") || role.equals("Human_Capital")) {
                    String approvedBy;
                    if (role.equals("Human_Capital")) {
                        EmployeeDto employeeDto = employeeService.getByUsername(username);
                        approvedBy = employeeDto.getFirst_Name() + " " + employeeDto.getLast_Name();
                    } else {
                        approvedBy = "ADMIN";
                    }
                    existingLeaves.setApprovedBy(approvedBy);
                    LeavesDto updatedLeaves = leavesService.update(LeavesID, existingLeaves);
                    return ResponseEntity.ok(updatedLeaves);
                } else {
                    return ResponseEntity.notFound().build();
                }
            } else {
                if (existingLeaves.getUsername().equals(username) || role.equals("ADMIN")
                        || role.equals("Human_Capital")) {
                    LeavesDto updatedLeaves = leavesService.update(LeavesID, existingLeaves);
                    return ResponseEntity.ok(updatedLeaves);
                }
                return ResponseEntity.notFound().build();
            }
        } else {
            if (existingLeaves.getUsername().equals(username) || role.equals("ADMIN") || role.equals("Human_Capital")) {
                LeavesDto updatedLeaves = leavesService.update(LeavesID, existingLeaves);
                return ResponseEntity.ok(updatedLeaves);
            }
            return ResponseEntity.notFound().build();
        }
    }

    // Build Delete Employee REST API
    @DeleteMapping("/delete/{LeavesID}")
    public ResponseEntity<String> deleteEmployee(@PathVariable("LeavesID") Integer LeavesID,
            @AuthenticationPrincipal Jwt jwt) {
        // Retrieve username and role from the jwt
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        LeavesDto leavesDto = leavesService.getByLeavesID(LeavesID);

        if (leavesDto.getUsername().equals(username) || role.equals("ADMIN") || role.equals("Human_Capital")) {
            leavesService.delete(LeavesID);
            return ResponseEntity.ok("Leave deleted successfully!");
        }
        return ResponseEntity.notFound().build();
    }

    public static String[] getNullPropertyNames(Object source) {
        return getStrings(source);
    }
}
