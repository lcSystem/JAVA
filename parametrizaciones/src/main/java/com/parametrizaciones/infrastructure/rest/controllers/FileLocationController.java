package com.parametrizaciones.infrastructure.rest.controllers;

import com.parametrizaciones.infrastructure.persistence.adapters.FileLocationAdapter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/public/file-locations")
@RequiredArgsConstructor
public class FileLocationController {

    private final FileLocationAdapter fileLocationAdapter;

    @GetMapping
    public ResponseEntity<List<FileLocationAdapter.DepartmentDto>> getAllLocations() {
        return ResponseEntity.ok(fileLocationAdapter.getCachedLocations());
    }

    @PostMapping("/validate")
    public ResponseEntity<Map<String, Boolean>> validateLocation(@RequestBody ValidationRequest request) {
        boolean isValid = fileLocationAdapter.validateLocation(request.departmentCode(), request.cityCode());
        return ResponseEntity.ok(Map.of("isValid", isValid));
    }

    public record ValidationRequest(String departmentCode, String cityCode) {
    }
}
