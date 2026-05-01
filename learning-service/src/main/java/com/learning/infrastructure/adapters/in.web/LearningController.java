package com.learning.infrastructure.adapters.in.web;

import com.learning.application.services.LearningPathService;
import com.learning.domain.model.Subject;
import com.learning.domain.model.Unit;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/learning")
@RequiredArgsConstructor
public class LearningController {

    private final LearningPathService learningPathService;

    @GetMapping("/subjects")
    public ResponseEntity<List<Subject>> getSubjects() {
        return ResponseEntity.ok(learningPathService.getAllSubjects());
    }

    @GetMapping("/subjects/{subjectId}/units")
    public ResponseEntity<List<Unit>> getUnits(@PathVariable String subjectId) {
        return ResponseEntity.ok(learningPathService.getUnitsForSubject(subjectId));
    }
}
