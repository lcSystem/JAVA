package com.allianceever.creditos.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "approval_audit")
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
}
