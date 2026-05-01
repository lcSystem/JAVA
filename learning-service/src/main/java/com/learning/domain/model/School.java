package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class School {
    private String id;
    private String name;
    private String district;
}
