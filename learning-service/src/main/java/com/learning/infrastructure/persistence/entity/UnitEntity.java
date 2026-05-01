package com.learning.infrastructure.persistence.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.List;

@Entity
@Table(name = "units")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UnitEntity {
    @Id
    private String id;

    @Column(nullable = false)
    private String name;

    private int orderIndex;

    @ManyToOne
    @JoinColumn(name = "subject_id")
    private SubjectEntity subject;

    @OneToMany(mappedBy = "unit", cascade = CascadeType.ALL)
    private List<LessonEntity> lessons;
}
