package com.learning.infrastructure.adapters.in.web;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.learning.application.ports.in.SubmitChallengeAnswerUseCase;
import com.learning.application.ports.in.StartLessonUseCase;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/learning")
@RequiredArgsConstructor
public class ChallengeController {

    private final StartLessonUseCase startLessonUseCase;
    private final SubmitChallengeAnswerUseCase submitAnswerUseCase;

    // Simulate JWT retrieval via AuthenticationPrincipal or SecurityContextHolder

    @PostMapping("/lessons/{lessonId}/start")
    public ResponseEntity<?> startLesson(@PathVariable String lessonId, @RequestHeader("Authorization") String token) {
        // Extract studentId from token (mocked)
        String studentId = "student-123";
        return ResponseEntity.ok(startLessonUseCase.startLesson(studentId, lessonId));
    }

    @PostMapping("/sessions/{sessionId}/challenges/{challengeId}/submit")
    public ResponseEntity<?> submitAnswer(
            @PathVariable String sessionId,
            @PathVariable String challengeId,
            @RequestBody Map<String, Object> request,
            @RequestHeader("Authorization") String token) {

        String studentId = "student-123"; // Simulated decode
        String answer = (String) request.get("answer");
        long responseTimeMs = ((Number) request.getOrDefault("responseTimeMs", 0)).longValue();

        Object result = submitAnswerUseCase.submitAnswer(studentId, sessionId, challengeId, answer, responseTimeMs);
        return ResponseEntity.ok(result);
    }
}
