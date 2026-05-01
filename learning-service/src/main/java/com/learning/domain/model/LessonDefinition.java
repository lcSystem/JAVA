package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LessonDefinition {
    private String id;
    private String unitId;
    private String title;
    private String description;
    private int xpReward;
    private int estimatedMinutes;
}
