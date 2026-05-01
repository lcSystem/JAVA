package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;

/**
 * Encapsulates adaptive learning rules for a student's session.
 */
@Getter
@Builder
public class AdaptiveRules {
    private int maxErrorsAllowed;
    private int fastResponseThresholdMs;
    private double difficultyFactor; // 1.0 = standard, < 1.0 = easier, > 1.0 = harder

    public static AdaptiveRules defaultRules() {
        return AdaptiveRules.builder()
                .maxErrorsAllowed(5)
                .fastResponseThresholdMs(3000)
                .difficultyFactor(1.0)
                .build();
    }
}
