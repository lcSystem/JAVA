package com.learning.infrastructure.persistence.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "lessons")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LessonEntity {
    @Id
    private String id;

    @Column(nullable = false)
    private String title;

    private String description;

    private int xpReward;

    @ManyToOne
    @JoinColumn(name = "unit_id")
    private UnitEntity unit;
}
