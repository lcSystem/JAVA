package com.projectERP.AuthenticatedBackend.controllers;

import com.projectERP.AuthenticatedBackend.models.ChangePasswordDTO;
import com.projectERP.model.dto.EmployeeDto;
import com.projectERP.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import com.projectERP.AuthenticatedBackend.models.UserProfileDTO;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;

import com.projectERP.AuthenticatedBackend.models.ApplicationUser;
import com.projectERP.AuthenticatedBackend.models.LoginResponseDTO;
import com.projectERP.AuthenticatedBackend.models.RegistrationDTO;
import com.projectERP.AuthenticatedBackend.services.AuthenticationService;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/auth")
public class AuthenticationController {

    @Autowired
    private AuthenticationService authenticationService;

    @Autowired
    private EmployeeService employeeService;

    // ---------------- Register ----------------
    @PostMapping("/register")
    public ResponseEntity<ApplicationUser> registerUser(@RequestBody RegistrationDTO body) {
        ApplicationUser user = authenticationService.registerUser(body.getUsername(), body.getPassword(),
                body.getRole());
        return ResponseEntity.ok(user);
    }

    // ---------------- Login ----------------
    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> loginUser(@RequestBody RegistrationDTO body) {
        LoginResponseDTO loginResponseDTO = authenticationService.loginUser(body.getUsername(), body.getPassword());
        if (loginResponseDTO.getUser() != null) {
            return ResponseEntity.ok(loginResponseDTO);
        } else {
            return ResponseEntity.status(401).build();
        }
    }

    // ---------------- Update user ----------------
    @PostMapping("/update")
    public ResponseEntity<ApplicationUser> updateUser(@RequestBody RegistrationDTO body) {
        ApplicationUser user = authenticationService.updateUser(body.getUsername(), body.getPassword(), body.getRole());
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // ---------------- Delete user ----------------
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteUser(@PathVariable("id") Long employeeID) {
        EmployeeDto employeeDto = employeeService.getById(employeeID);
        if (employeeDto != null) {
            authenticationService.delete(employeeDto.getUserName());
            return ResponseEntity.ok("User deleted successfully!");
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // ---------------- Change Password ----------------
    @PostMapping("/changePassword")
    public ResponseEntity<String> changePassword(@RequestBody ChangePasswordDTO body,
            @AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        String role = jwt.getClaimAsString("roles");

        LoginResponseDTO loginResponseDTO = authenticationService.loginUser(username, body.getOldPassword());
        if (loginResponseDTO.getUser() != null && !body.getNewPassword().isEmpty()) {
            ApplicationUser updatedUser = authenticationService.updateUser(username, body.getNewPassword(), role);
            if (updatedUser != null) {
                return ResponseEntity.ok("Password changed successfully!");
            } else {
                return ResponseEntity.notFound().build();
            }
        } else {

            return ResponseEntity.status(400).body("Invalid old password or new password is empty");
        }
    }

    // ---------------- Profile ----------------
    @GetMapping("/profile")
    public ResponseEntity<UserProfileDTO> getUserProfile(@AuthenticationPrincipal Jwt jwt) {
        String username = jwt.getClaimAsString("sub");
        UserProfileDTO profile = authenticationService.getUserProfile(username);
        return ResponseEntity.ok(profile);
    }

    @PostMapping("/profile")
    public ResponseEntity<ApplicationUser> updateUserProfile(@AuthenticationPrincipal Jwt jwt,
            @RequestBody UserProfileDTO body) {
        String username = jwt.getClaimAsString("sub");
        ApplicationUser updatedUser = authenticationService.updateUserProfile(username, body);
        return ResponseEntity.ok(updatedUser);
    }

    @PostMapping("/profile/image")
    public ResponseEntity<String> uploadProfileImage(@AuthenticationPrincipal Jwt jwt,
            @RequestParam("file") MultipartFile file) {
        String username = jwt.getClaimAsString("sub");
        try {
            String fileUrl = authenticationService.uploadProfileImage(username, file);
            return ResponseEntity.ok(fileUrl);
        } catch (IOException e) {
            return ResponseEntity.status(500).body("Error uploading image: " + e.getMessage());
        }
    }
}
