package com.allianceever.projectERP.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EstimatesInvoicesDto {

    private Long id;

    private String type;

    private ClientDto client;

    private ProjectDto project;

    private LocalDate createDate;

    private LocalDate estimateDate;

    private LocalDate expiryDate;

    private BigDecimal total;

    private String otherInfo;

    private String status;

    private Integer tax;

    private List<ItemDto> items;

}
