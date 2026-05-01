package com.learning.domain.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ChallengeVersion {
    private String id;
    private String challengeId;
    private String lessonVersionId; // Ties this challenge state to a specific lesson version
    private int orderIndex;
    private int awardedXp;
}
