package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class Challenge {
    private String id;
    private String lessonDefinitionId;
    private ChallengeType type;

    // Dynamic content definition (e.g., JSON string or specific object map
    // depending on type)
    private String content;

    // Additional rules (e.g., {"tolerance": 0.01} for numeric)
    private String validationRules;

    // Any other UI metadata or hints
    private String metadata;
}
