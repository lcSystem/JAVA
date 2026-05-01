package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class Grade {
    private String id;
    private String schoolId;
    private String name; // e.g., "6th Grade"
    private int gradeLevel; // e.g., 6
}
