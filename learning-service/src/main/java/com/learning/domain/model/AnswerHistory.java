package com.learning.domain.model;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class AnswerHistory {
    private String id;
    private String studentId;
    private String challengeVersionId;
    private String subjectId;
    private boolean isCorrect;
    private String studentAnswer;
    private long responseTimeMilliSeconds;
    private LocalDateTime timestamp;
}
