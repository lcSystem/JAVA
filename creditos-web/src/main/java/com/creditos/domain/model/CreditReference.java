package com.creditos.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
@Builder
public class CreditReference {
    private final Long id;
    private final Long ownerId;
    private final String ownerType; // 'APPLICANT' or 'CO_DEBTOR'
    private final String referenceType; // 'FAMILY' or 'PERSONAL'
    private final String fullName;
    private final String relationship;
    private final String phone;
    private final LocalDateTime createdAt;
}
