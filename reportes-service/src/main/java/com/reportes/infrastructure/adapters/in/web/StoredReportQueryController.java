package com.reportes.infrastructure.adapters.in.web;

import com.reportes.application.services.StoredReportQueryService;
import com.reportes.domain.model.dynamic.StoredReportQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reports/stored-queries")
@RequiredArgsConstructor
public class StoredReportQueryController {

    private final StoredReportQueryService storedReportQueryService;

    @GetMapping
    public ResponseEntity<List<StoredReportQuery>> getAll() {
        return ResponseEntity.ok(storedReportQueryService.getAllQueries());
    }

    @GetMapping("/{id}")
    public ResponseEntity<StoredReportQuery> getById(@PathVariable String id) {
        return storedReportQueryService.getQueryById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<StoredReportQuery> save(@RequestBody StoredReportQuery queryData) {
        // Here we could extract context username, e.g.
        // "SecurityContextHolder.getContext().getAuthentication().getName()"
        // Using "ADMIN" as fallback for now
        StoredReportQuery saved = storedReportQueryService.saveQuery(queryData, "ADMIN");
        return ResponseEntity.ok(saved);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        storedReportQueryService.deleteQuery(id);
        return ResponseEntity.noContent().build();
    }
}
