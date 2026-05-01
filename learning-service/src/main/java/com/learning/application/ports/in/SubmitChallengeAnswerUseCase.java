package com.learning.application.ports.in;

public interface SubmitChallengeAnswerUseCase {
    Object submitAnswer(String studentId, String sessionId, String challengeId, String answer, long responseTimeMs);
}
