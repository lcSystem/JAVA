package com.allianceever.portfolio.infrastructure.rest.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.UUID;

@Data
public class MoveRequest {
    @NotNull(message = "Target folder ID is required (use null for root)")
    private UUID targetFolderId;
}
