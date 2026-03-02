package com.creditos.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "approval_audit")
@org.hibernate.annotations.SQLDelete(sql = "UPDATE approval_audit SET deleted_at = NOW() WHERE id = ?")
@org.hibernate.annotations.Where(clause = "deleted_at IS NULL")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApprovalAudit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "request_id", nullable = false)
    private CreditRequest request;

    @Column(name = "approver_username", nullable = false, length = 100)
    private String approverUsername;

    @CreationTimestamp
    @Column(name = "approval_date")
    private LocalDateTime approvalDate;

    @Column(nullable = false, length = 50)
    private String decision;

    @Column(columnDefinition = "TEXT")
    private String comments;

    @Column(columnDefinition = "TEXT")
    private String conditions;

    @Version
    private Long version;

    @Column(name = "created_by")
    private String createdBy;

    @Column(name = "updated_by")
    private String updatedBy;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;
}
