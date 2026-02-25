package com.reportes.infrastructure.persistence.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "dynamic_report_history")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DynamicReportHistoryEntity {

    @Id
    @org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.VARCHAR)
    @Column(length = 36)
    private UUID id;

    @Column(name = "template_id", length = 36, nullable = false)
    @org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.VARCHAR)
    private UUID templateId;

    @Column(name = "template_name")
    private String templateName;

    @Column(name = "microservice_id")
    private String microserviceId;

    @Column(name = "entity_id")
    private String entityId;

    @Column(name = "format", length = 20)
    private String format;

    @Column(name = "created_by")
    private String createdBy;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
