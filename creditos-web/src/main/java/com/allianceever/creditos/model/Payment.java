package com.allianceever.creditos.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "payments")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "installment_id", nullable = false)
    private AmortizationInstallment installment;

    @CreationTimestamp
    @Column(name = "payment_date")
    private LocalDateTime paymentDate;

    @Column(name = "amount_paid", nullable = false)
    private BigDecimal amountPaid;

    @Column(name = "payment_type", nullable = false, length = 50)
    private String paymentType; // NORMAL, ADVANCED, PARTIAL

    @Column(name = "receipt_number", length = 100)
    private String receiptNumber;
}
