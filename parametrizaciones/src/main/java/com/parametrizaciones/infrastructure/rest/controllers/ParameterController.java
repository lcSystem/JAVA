package com.parametrizaciones.infrastructure.rest.controllers;

import com.parametrizaciones.domain.model.Parameter;
import com.parametrizaciones.domain.ports.in.ParameterServicePort;
import com.parametrizaciones.infrastructure.rest.dto.ParameterDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/parameters")
@RequiredArgsConstructor
public class ParameterController {

    private final ParameterServicePort parameterService;

    @GetMapping("/{service}")
    public ResponseEntity<List<ParameterDto>> getParametersByService(@PathVariable String service) {
        List<ParameterDto> dtos = parameterService.getParametersByService(service).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/{service}/{key}")
    public ResponseEntity<ParameterDto> getParameterByServiceAndKey(@PathVariable String service,
            @PathVariable String key) {
        return parameterService.getParameterByServiceAndKey(service, key)
                .map(param -> ResponseEntity.ok(mapToDto(param)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<ParameterDto> createParameter(@RequestBody ParameterDto dto) {
        Parameter param = mapToDomain(dto);
        param.setCreatedBy(getCurrentUser());
        Parameter saved = parameterService.createParameter(param);
        return ResponseEntity.status(HttpStatus.CREATED).body(mapToDto(saved));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ParameterDto> updateParameter(@PathVariable Long id, @RequestBody ParameterDto dto) {
        Parameter param = mapToDomain(dto);
        param.setUpdatedBy(getCurrentUser());
        Parameter updated = parameterService.updateParameter(id, param);
        return ResponseEntity.ok(mapToDto(updated));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteParameter(@PathVariable Long id) {
        parameterService.deleteParameter(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}/hard")
    public ResponseEntity<Void> hardDeleteParameter(@PathVariable Long id) {
        parameterService.hardDeleteParameter(id);
        return ResponseEntity.noContent().build();
    }

    private String getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null ? authentication.getName() : "system";
    }

    private ParameterDto mapToDto(Parameter param) {
        return ParameterDto.builder()
                .id(param.getId())
                .categoryName(param.getCategory() != null ? param.getCategory().getName() : null)
                .serviceName(param.getServiceName())
                .name(param.getName())
                .key(param.getKey())
                .value(param.getValue())
                .type(param.getType())
                .version(param.getVersion())
                .enabled(param.isEnabled())
                .createdAt(param.getCreatedAt())
                .updatedAt(param.getUpdatedAt())
                .createdBy(param.getCreatedBy())
                .updatedBy(param.getUpdatedBy())
                .build();
    }

    private Parameter mapToDomain(ParameterDto dto) {
        return Parameter.builder()
                .serviceName(dto.getServiceName())
                .name(dto.getName())
                .key(dto.getKey())
                .value(dto.getValue())
                .type(dto.getType())
                .enabled(dto.isEnabled())
                .build();
    }
}
