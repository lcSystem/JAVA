package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class Subject {
    private String id;
    private String gradeId;
    private String name; // e.g., "Mathematics", "English"
    private String description;
}
