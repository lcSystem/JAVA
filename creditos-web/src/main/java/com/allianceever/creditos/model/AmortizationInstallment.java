package com.allianceever.creditos.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "amortization_schedule")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AmortizationInstallment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "request_id", nullable = false)
    private CreditRequest request;

    @Column(name = "installment_number", nullable = false)
    private Integer installmentNumber;

    @Column(name = "due_date", nullable = false)
    private LocalDate dueDate;

    @Column(name = "principal_amount", nullable = false)
    private BigDecimal principalAmount;

    @Column(name = "interest_amount", nullable = false)
    private BigDecimal interestAmount;

    @Builder.Default
    @Column(name = "insurance_amount")
    private BigDecimal insuranceAmount = BigDecimal.ZERO;

    @Column(name = "total_installment", nullable = false)
    private BigDecimal totalInstallment;

    @Column(name = "remaining_balance", nullable = false)
    private BigDecimal remainingBalance;

    @Column(nullable = false, length = 50)
    private String status; // PENDING, PAID, OVERDUE
}
