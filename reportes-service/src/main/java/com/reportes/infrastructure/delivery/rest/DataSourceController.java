package com.reportes.infrastructure.delivery.rest;

import com.reportes.domain.model.dynamic.DataSourceConfig;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/dynamic-reports/data-sources")
public class DataSourceController {
        private final com.reportes.application.services.dynamic.DataSourceRegistryService registryService;

        public DataSourceController(
                        com.reportes.application.services.dynamic.DataSourceRegistryService registryService) {
                this.registryService = registryService;
        }

        @GetMapping
        public ResponseEntity<List<DataSourceConfig>> getDataSources(
                        org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken authentication) {
                java.util.Set<String> roles = authentication.getToken().getClaimAsStringList("roles") != null
                                ? new java.util.HashSet<>(authentication.getToken().getClaimAsStringList("roles"))
                                : java.util.Set.of();

                return ResponseEntity.ok(registryService.getAllAllowedForUser(roles));
        }
}
