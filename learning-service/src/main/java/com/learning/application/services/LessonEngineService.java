package com.learning.application.services;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import com.learning.application.ports.in.StartLessonUseCase;
import com.learning.application.ports.in.GetNextChallengeUseCase;
import com.learning.application.ports.in.SubmitChallengeAnswerUseCase;
import com.learning.application.ports.in.CompleteLessonUseCase;
import com.learning.domain.model.Challenge;
import com.learning.domain.model.LessonSession;
import com.learning.domain.model.LessonStatus;
import com.learning.domain.model.StudentProgress;
import com.learning.domain.model.LessonProgress;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class LessonEngineService
        implements StartLessonUseCase, GetNextChallengeUseCase, SubmitChallengeAnswerUseCase, CompleteLessonUseCase {

    // Dependencies would normally be injected here (Repositories, etc.)

    @Override
    public LessonSession startLesson(String studentId, String lessonDefinitionId) {
        // Create new session, reset hearts to 5
        return LessonSession.builder()
                .id(UUID.randomUUID().toString())
                .studentId(studentId)
                .lessonId(lessonDefinitionId)
                .currentChallengeIndex(0)
                .correctAnswers(0)
                .wrongAnswers(0)
                .heartsRemaining(5)
                .status(LessonStatus.IN_PROGRESS)
                .build();
    }

    @Override
    public Challenge getNextChallenge(String sessionId) {
        // Implementation: Fetch active session, query ordered challenges, determine
        // next.
        // For gamification: if the user failed the previous, we might present an easier
        // challenge here
        // if adapting dynamically.
        return Challenge.builder()
                .id(UUID.randomUUID().toString())
                .type(com.learning.domain.model.ChallengeType.MULTIPLE_CHOICE)
                .content("{\"question\": \"What is 2+2?\", \"options\": [\"3\", \"4\", \"5\"], \"correct\": \"4\"}")
                .build();
    }

    @Override
    public Object submitAnswer(String studentId, String sessionId, String challengeId, String answer,
            long responseTimeMs) {
        // Mock verification logic
        boolean isCorrect = evaluateAnswer(challengeId, answer);
        long xpEarned = isCorrect ? 10L : 0L;

        // Adaptive Rule Formula Application:
        // if (timeMs < 2000) xpEarned += 5; // speed bonus

        return new AnswerResult(isCorrect, xpEarned, isCorrect ? "Correct!" : "Incorrect");
    }

    @Override
    public LessonProgress completeLesson(String sessionId) {
        // Aggregate session results into LessonProgress status -> COMPLETED
        return LessonProgress.builder()
                .id(UUID.randomUUID().toString())
                .lessonVersionId("v1")
                .studentId("std-1")
                .isCompleted(true)
                .score(100)
                .build();
    }

    private boolean evaluateAnswer(String challengeId, String answer) {
        // Logic depends on ChallengeType and validationRules.
        return true;
    }

    // DTO for response
    public static class AnswerResult {
        public boolean correct;
        public long xpEarned;
        public String feedback;

        public AnswerResult(boolean correct, long xpEarned, String feedback) {
            this.correct = correct;
            this.xpEarned = xpEarned;
            this.feedback = feedback;
        }
    }
}
