package com.projectERP.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Table(name = "expenses")
public class Expenses {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Id;

    private String itemName;

    private String purchaseFrom;

    @Column(name = "purchase_date")
    private LocalDate purchaseDate;

    private String purchasedBy;

    private BigDecimal Amount;

    private String paidBy;

    private String Status;

    @Lob
    @Column(columnDefinition = "LONGBLOB")
    private byte[] data;
}
