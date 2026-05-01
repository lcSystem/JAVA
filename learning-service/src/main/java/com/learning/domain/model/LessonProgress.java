package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

public enum LessonStatus {
    LOCKED,
    UNLOCKED,
    IN_PROGRESS,
    COMPLETED,
    FAILED
}

@Getter
@Setter
@Builder
public class LessonProgress {
    private String id;
    private String studentId;
    private String lessonDefinitionId;
    private String lessonVersionId; // The specific version they are progressing against
    private LessonStatus status;
    private int score;
    private int attempts;
}
