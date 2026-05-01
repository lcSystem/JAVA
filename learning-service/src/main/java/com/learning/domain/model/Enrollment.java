package com.learning.domain.model;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class Enrollment {
    private String id;
    private String studentId;
    private String subjectId;
    private LocalDateTime enrolledAt;
    private boolean isActive;
}
