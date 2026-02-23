package com.allianceever.creditos.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@AllArgsConstructor
@Builder
public class Reference {
    private final Long id;
    private final String fullName;
    private final String phone;
    private final String relationship;
    private final String type; // PERSONAL, FAMILY
}
