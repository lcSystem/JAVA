package com.learning.infrastructure.adapters.in.web;

import com.learning.application.services.LessonEngineService;
import com.learning.domain.model.Challenge;
import com.learning.domain.model.LessonSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/lessons")
@RequiredArgsConstructor
public class LessonController {

    private final LessonEngineService lessonEngineService;

    @PostMapping("/{lessonId}/start")
    public ResponseEntity<LessonSession> startLesson(@PathVariable String lessonId, @RequestParam String studentId) {
        LessonSession session = lessonEngineService.startLesson(studentId, lessonId);
        return ResponseEntity.ok(session);
    }

    @GetMapping("/sessions/{sessionId}/next-challenge")
    public ResponseEntity<Challenge> getNextChallenge(@PathVariable String sessionId) {
        return ResponseEntity.ok(lessonEngineService.getNextChallenge(sessionId));
    }

    @PostMapping("/sessions/{sessionId}/challenges/{challengeId}/submit")
    public ResponseEntity<Object> submitAnswer(
            @PathVariable String sessionId,
            @PathVariable String challengeId,
            @RequestParam String studentId,
            @RequestBody AnswerPayload payload) {

        Object response = lessonEngineService.submitAnswer(
                studentId, sessionId, challengeId, payload.getAnswer(), payload.getResponseTimeMs());
        return ResponseEntity.ok(response);
    }

    public static class AnswerPayload {
        private String answer;
        private long responseTimeMs;

        public String getAnswer() {
            return answer;
        }

        public void setAnswer(String answer) {
            this.answer = answer;
        }

        public long getResponseTimeMs() {
            return responseTimeMs;
        }

        public void setResponseTimeMs(long timeMs) {
            this.responseTimeMs = timeMs;
        }
    }
}
