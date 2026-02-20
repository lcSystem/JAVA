package com.reportes.domain.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class InternalProcessingEvent {
    private UUID reportId;
    private int retryCount;
}
