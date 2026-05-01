package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class Student {
    private String id;
    private String schoolId;
    private String name;
    private String email;
}
