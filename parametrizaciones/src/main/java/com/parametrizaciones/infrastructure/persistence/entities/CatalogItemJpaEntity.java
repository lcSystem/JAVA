package com.parametrizaciones.infrastructure.persistence.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.SQLRestriction;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "catalog_item", uniqueConstraints = {
        @UniqueConstraint(name = "uk_catalog_item_tenant_code", columnNames = { "catalog_code", "item_code",
                "company_id" })
})
@SQLRestriction("deleted = false")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CatalogItemJpaEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "catalog_code", nullable = false)
    private String catalogCode;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "company_id")
    private Long companyId;

    @Column(name = "item_code", nullable = false)
    private String code;

    @Column(nullable = false)
    private String name;

    private String description;

    @Builder.Default
    @Column(name = "order_index")
    private Integer orderIndex = 0;

    private String path;

    @Builder.Default
    private Integer level = 0;

    @Column(name = "extra_data", columnDefinition = "json")
    private String extraData;

    @Builder.Default
    @Column(nullable = false)
    private boolean enabled = true;

    @Builder.Default
    @Column(nullable = false)
    private boolean deleted = false;

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
