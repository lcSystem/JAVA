package com.portfolio.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PortfolioSettings {
    private int maxFileSizeMb;
    private List<String> allowedExtensions;
    private boolean requireReAuth;
}
