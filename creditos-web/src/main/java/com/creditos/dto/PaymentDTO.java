package com.creditos.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PaymentDTO {
    private Long id;
    private Long installmentId;
    private LocalDateTime paymentDate;
    private BigDecimal amountPaid;
    private String paymentType;
    private String receiptNumber;
}
