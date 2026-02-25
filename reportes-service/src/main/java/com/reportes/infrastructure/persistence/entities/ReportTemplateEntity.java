package com.reportes.infrastructure.persistence.entities;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "dynamic_report_templates")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReportTemplateEntity {

    @Id
    @Column(length = 36, columnDefinition = "VARCHAR(36)")
    @JdbcTypeCode(SqlTypes.VARCHAR)
    private UUID id;

    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    // Use JSON columns but mapped to longtext for Hibernate schema validation
    // compatibility
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "longtext")
    private String config; // Stored as JSON string

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "longtext")
    private String columns; // Stored as JSON string

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "longtext")
    private String charts; // Stored as JSON string

    private String createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
