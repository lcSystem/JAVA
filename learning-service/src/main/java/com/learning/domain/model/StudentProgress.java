package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

/**
 * Tracks the gamified progress of a student within a specific Subject.
 */
@Getter
@Setter
@Builder
public class StudentProgress {
    private String id;
    private String studentId;
    private String subjectId;

    private int level;
    private long totalXp;
    private int currentStreakDays;
    private long lastParticipationDateEpochMs;
    private int hearts;

    // In Duolingo, hearts refill over time or by practicing. Max hearts is usually
    // 5.
    public static final int MAX_HEARTS = 5;

    public void addXp(long xp) {
        this.totalXp += xp;
    }

    public void removeHeart() {
        if (this.hearts > 0) {
            this.hearts--;
        }
    }

    public void refillHearts() {
        this.hearts = MAX_HEARTS;
    }

    public void updateStreak(long todayEpochMs) {
        // Logic to update streak if todayEpochMs is 1 day after lastParticipation
        // or reset to 1 if more than a day passed. Simplified for architecture design.
        this.currentStreakDays++;
        this.lastParticipationDateEpochMs = todayEpochMs;
    }
}
