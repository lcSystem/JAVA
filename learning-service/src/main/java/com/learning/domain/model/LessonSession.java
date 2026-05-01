package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class LessonSession {
    private String id;
    private String studentId;
    private String lessonId; // Reference to the lesson concept
    private int currentChallengeIndex;
    private int correctAnswers;
    private int wrongAnswers;
    private int heartsRemaining;
    private LessonStatus status;
}
