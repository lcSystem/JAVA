package com.learning.domain.model;

import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

/**
 * Adaptive engine that adjusts lesson complexity based on performance metrics.
 */
public class AdaptiveEngine {

    public static double calculateNextDifficulty(int errors, long averageResponseTimeMs, double currentDifficulty) {
        double adjustment = 0.0;

        // Rule: If high errors, decrease difficulty
        if (errors > 3) {
            adjustment -= 0.1;
        } else if (errors == 0) {
            adjustment += 0.05;
        }

        // Rule: If very fast and correct, increase difficulty
        if (errors == 0 && averageResponseTimeMs < 2000) {
            adjustment += 0.1;
        }

        return Math.max(0.5, Math.min(2.0, currentDifficulty + adjustment));
    }

    public static Map<String, Object> getAdaptiveFeedback(int errors, int streak) {
        Map<String, Object> feedback = new HashMap<>();
        if (errors > 2) {
            feedback.put("tip", "Don't worry! Let's try something a bit easier.");
            feedback.put("action", "SIMPLIFY_NEXT");
        }
        if (streak > 5) {
            feedback.put("congrats", "You're on fire! " + streak + " day streak!");
        }
        return feedback;
    }
}
