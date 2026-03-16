package com.clientauth.controller;

import com.clientauth.dto.ConfigCreditosResponse;
import com.clientauth.service.ConfigCreditosService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/config-creditos")
@RequiredArgsConstructor
public class ConfigCreditosController {

    private final ConfigCreditosService configService;

    /**
     * Get all design configuration for the mobile credit app.
     * Public endpoint — consumed by the Flutter app at startup.
     */
    @GetMapping
    public ResponseEntity<ConfigCreditosResponse> getAllConfig() {
        Map<String, String> config = configService.getAllConfig();
        return ResponseEntity.ok(ConfigCreditosResponse.builder().config(config).build());
    }

    /**
     * Get a specific config value by key.
     * Public endpoint.
     */
    @GetMapping("/{key}")
    public ResponseEntity<Map<String, String>> getConfigByKey(@PathVariable String key) {
        String value = configService.getConfigByKey(key);
        if (value == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(Map.of("key", key, "value", value));
    }

    /**
     * Update a config value.
     * Requires admin authentication (protected by gateway or admin check).
     */
    @PutMapping("/{key}")
    public ResponseEntity<Void> updateConfig(@PathVariable String key,
            @RequestBody Map<String, String> body) {
        String value = body.get("value");
        if (value == null) {
            return ResponseEntity.badRequest().build();
        }
        configService.updateConfig(key, value);
        return ResponseEntity.ok().build();
    }
}
