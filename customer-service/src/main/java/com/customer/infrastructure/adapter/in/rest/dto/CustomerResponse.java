package com.customer.infrastructure.adapter.in.rest.dto;

import com.customer.domain.model.CustomerStatus;
import com.customer.domain.model.CustomerType;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class CustomerResponse {
    private Long id;
    private CustomerType type;
    private String name;
    private String documentNumber;
    private String email;
    private String phone;
    private CustomerStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String createdBy;
    private String updatedBy;
    private List<CustomerAddressDto> addresses;
    private List<CustomerContactDto> contacts;
    private List<CustomerNoteDto> notes;
    private List<CustomerHistoryDto> history;
}
