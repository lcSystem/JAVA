package com.creditos.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PreviousCredit {
    private Long id;
    private String bankName;
    private BigDecimal amount;
    private String status;
    private BigDecimal monthlyInstallment;
}
