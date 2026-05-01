package com.learning.infrastructure.persistence.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.List;

@Entity
@Table(name = "subjects")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SubjectEntity {
    @Id
    private String id;

    @Column(nullable = false)
    private String name;

    private String description;

    @OneToMany(mappedBy = "subject", cascade = CascadeType.ALL)
    private List<UnitEntity> units;
}
