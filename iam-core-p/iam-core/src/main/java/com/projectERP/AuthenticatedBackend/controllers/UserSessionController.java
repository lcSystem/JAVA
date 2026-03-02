package com.projectERP.AuthenticatedBackend.controllers;

import com.projectERP.AuthenticatedBackend.models.SessionStatus;
import com.projectERP.AuthenticatedBackend.models.UserSession;
import com.projectERP.AuthenticatedBackend.services.UserSessionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/api/sessions")
@CrossOrigin(origins = "http://localhost:3000")
public class UserSessionController {

    @Autowired
    private UserSessionService sessionService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Page<UserSession>> getSessions(
            @RequestParam(required = false) SessionStatus status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "startTime") String sortBy) {

        PageRequest pageRequest = PageRequest.of(page, size, Sort.by(sortBy).descending());
        return ResponseEntity.ok(sessionService.getSessions(status, pageRequest));
    }

    @PostMapping("/{id}/close")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> adminCloseSession(@PathVariable Long id, Principal principal) {
        sessionService.closeSession(id, principal.getName(), "ADMIN_ACTION");
        return ResponseEntity.ok().build();
    }

    @PostMapping("/close-self")
    public ResponseEntity<Void> closeSelf(@RequestHeader("Authorization") String token, Principal principal) {
        if (token != null && token.startsWith("Bearer ")) {
            String jwt = token.substring(7);
            sessionService.closeSessionByToken(jwt, principal.getName(), "SELF_LOGOUT");
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.badRequest().build();
    }
}
