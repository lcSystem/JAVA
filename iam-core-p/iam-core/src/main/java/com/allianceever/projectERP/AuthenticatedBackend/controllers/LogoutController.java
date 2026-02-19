package com.allianceever.projectERP.AuthenticatedBackend.controllers;

import com.allianceever.projectERP.AuthenticatedBackend.models.BlacklistedToken;
import com.allianceever.projectERP.AuthenticatedBackend.repository.TokenBlacklistRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "http://localhost:3000")
@RestController
@RequestMapping("/api/logout")
public class LogoutController {

    private final TokenBlacklistRepository blacklistRepository;

    @Autowired
    public LogoutController(TokenBlacklistRepository blacklistRepository) {
        this.blacklistRepository = blacklistRepository;
    }

    @PostMapping
    public ResponseEntity<String> logout(@RequestHeader("Authorization") String token) {
        // Extraer el token del header "Authorization"
        if(token == null || !token.startsWith("Bearer ")) {
            return ResponseEntity.badRequest().body("Invalid token header");
        }
        String jwtToken = token.substring(7); // Remove "Bearer "

        // Guardar en blacklist
        BlacklistedToken blacklistedToken = new BlacklistedToken(jwtToken);
        blacklistRepository.save(blacklistedToken);

        return ResponseEntity.ok("Logout successful");
    }
}
