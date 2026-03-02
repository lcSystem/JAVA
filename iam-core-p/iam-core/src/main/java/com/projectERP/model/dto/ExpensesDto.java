package com.projectERP.model.dto;

import jakarta.persistence.Lob;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ExpensesDto {

    private Long Id;

    private String itemName;

    private String purchaseFrom;

    private LocalDate purchaseDate;

    private String purchasedBy;

    private BigDecimal Amount;

    private String paidBy;

    private String Status;

    @Lob
    private byte[] data;
}
