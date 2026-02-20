package com.allianceever.creditos.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "co_debtor_profiles")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CoDebtorProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "document_id", length = 50, nullable = false, unique = true)
    private String documentId;

    @Column(name = "birth_date")
    private LocalDate birthDate;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "address")
    private String address;

    @Column(name = "email", length = 100)
    private String email;

    // Laboral Info
    @Column(name = "company_name")
    private String companyName;

    @Column(name = "position", length = 100)
    private String position;

    @Column(name = "employment_years")
    private Integer employmentYears;

    @Column(name = "work_phone", length = 20)
    private String workPhone;

    // Financial Info
    @Column(name = "monthly_income", precision = 19, scale = 2)
    private BigDecimal monthlyIncome;

    @Column(name = "other_income", precision = 19, scale = 2)
    private BigDecimal otherIncome;

    @Column(name = "monthly_expenses", precision = 19, scale = 2)
    private BigDecimal monthlyExpenses;

    @Column(name = "is_legal_representative")
    private boolean isLegalRepresentative;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
