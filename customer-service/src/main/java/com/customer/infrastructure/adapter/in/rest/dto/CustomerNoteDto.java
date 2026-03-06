package com.customer.infrastructure.adapter.in.rest.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CustomerNoteDto {
    private Long id;
    private String note;
    private String createdBy;
    private LocalDateTime createdAt;
}
