package com.projectERP.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Table(name = "item")

public class Item {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "item_id")
    private Long itemID;

    private String name;

    private String description;

    private double uniteCost;

    private Integer quantity;

    private double amount;

    @ManyToOne
    @JoinColumn(name = "estimate_invoices_id")
    private EstimatesInvoices estimateInvoices;

}
