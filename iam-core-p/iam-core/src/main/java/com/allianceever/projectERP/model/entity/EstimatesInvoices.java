package com.allianceever.projectERP.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Table(name = "estimates_invoices")

public class EstimatesInvoices {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String type;

    @ManyToOne
    @JoinColumn(name = "client_id")
    private Client client;

    @ManyToOne
    @JoinColumn(name = "project_id")
    private Project project;

    private LocalDate createDate;

    private LocalDate estimateDate;

    private LocalDate expiryDate;

    private BigDecimal total;

    private String otherInfo;

    private String status;

    private Integer tax;

    @OneToMany(mappedBy = "estimateInvoices", cascade = CascadeType.ALL)
    private List<Item> items;

}
