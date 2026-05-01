package com.learning.domain.model;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LessonVersion {
    private String id;
    private String lessonDefinitionId;
    private String versionTag; // e.g., "v1.0.0"
    private String contentHash; // For integrity
    private LocalDateTime publishedAt;
    private int totalXpAvailable;
}
