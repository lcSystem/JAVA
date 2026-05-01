package com.learning.infrastructure.persistence.entity;

import com.learning.domain.model.ChallengeType;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "challenges")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChallengeEntity {
    @Id
    private String id;

    @Enumerated(EnumType.STRING)
    private ChallengeType type;

    @Column(columnDefinition = "TEXT")
    private String content; // JSON payload

    @Column(columnDefinition = "TEXT")
    private String validationRules;

    @ManyToOne
    @JoinColumn(name = "lesson_id")
    private LessonEntity lesson;
}
