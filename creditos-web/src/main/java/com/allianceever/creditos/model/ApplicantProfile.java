package com.allianceever.creditos.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "applicant_profiles")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApplicantProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "monthly_income", nullable = false)
    private BigDecimal monthlyIncome;

    @Column(name = "monthly_expenses", nullable = false)
    private BigDecimal monthlyExpenses;

    @Column(name = "current_debts", nullable = false)
    private BigDecimal currentDebts;

    @Column(name = "credit_score")
    private Integer creditScore;

    @UpdateTimestamp
    @Column(name = "last_updated")
    private LocalDateTime lastUpdated;
}
