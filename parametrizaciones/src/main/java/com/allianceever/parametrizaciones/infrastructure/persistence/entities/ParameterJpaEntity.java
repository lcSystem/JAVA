package com.allianceever.parametrizaciones.infrastructure.persistence.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "parameter", uniqueConstraints = {
        @UniqueConstraint(name = "uk_parameter_service_key", columnNames = { "service_name", "param_key" })
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParameterJpaEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private ParameterCategoryJpaEntity category;

    @Column(name = "service_name", nullable = false)
    private String serviceName;

    @Column(name = "name")
    private String name;

    @Column(name = "param_key", nullable = false)
    private String key;

    @Column(name = "param_value", nullable = false, columnDefinition = "TEXT")
    private String value;

    @Column(name = "param_type", nullable = false)
    private String type;

    @Version
    private Integer version;

    @Column(nullable = false)
    private boolean enabled = true;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "created_by")
    private String createdBy;

    @Column(name = "updated_by")
    private String updatedBy;
}
