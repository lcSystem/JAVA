package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LessonUnlockRule {
    private String lessonId;
    private String requiredPreviousLessonId;
    private long requiredXpInSubject;
    private int requiredLevelInSubject;

    public boolean isUnlocked(boolean isPreviousLessonCompleted, long currentXp, int currentLevel) {
        if (requiredPreviousLessonId != null && !isPreviousLessonCompleted) {
            return false;
        }
        if (requiredXpInSubject > 0 && currentXp < requiredXpInSubject) {
            return false;
        }
        if (requiredLevelInSubject > 0 && currentLevel < requiredLevelInSubject) {
            return false;
        }
        return true;
    }
}
