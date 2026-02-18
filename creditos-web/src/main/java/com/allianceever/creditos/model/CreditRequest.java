package com.allianceever.creditos.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "credit_requests")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreditRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "applicant_id", nullable = false)
    private ApplicantProfile applicant;

    @ManyToOne
    @JoinColumn(name = "credit_type_id", nullable = false)
    private CreditType creditType;

    @Column(nullable = false)
    private BigDecimal amount;

    @Column(name = "term_months", nullable = false)
    private Integer termMonths;

    @Column(columnDefinition = "TEXT")
    private String purpose;

    @Column(nullable = false, length = 50)
    private String status; // DRAFT, EVALUATING, APPROVED, REJECTED, DISBURSED

    @Column(name = "scoring_result", length = 50)
    private String scoringResult;

    @Column(name = "scoring_recommendation", columnDefinition = "TEXT")
    private String scoringRecommendation;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
