package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class Unit {
    private String id;
    private String subjectId;
    private String name; // e.g., "Fractions"
    private int orderIndex; // 0, 1, 2...
}
