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

                java.util.Set<String> roles = extractRoles(authentication.getToken());

                return ResponseEntity.ok(registryService.getAllAllowedForUser(roles));
        }

        private java.util.Set<String> extractRoles(org.springframework.security.oauth2.jwt.Jwt jwt) {
                java.util.Set<String> roles = new java.util.HashSet<>();
                Object rolesClaim = jwt.getClaim("roles");
                if (rolesClaim instanceof String) {
                        for (String r : ((String) rolesClaim).split(" ")) {
                                roles.add(r.replaceFirst("^ROLE_", ""));
                        }
                } else if (rolesClaim instanceof java.util.List) {
                        for (Object r : (java.util.List<?>) rolesClaim) {
                                roles.add(r.toString().replaceFirst("^ROLE_", ""));
                        }
                }
                return roles;
        }
}
