package com.allianceever.portfolio.domain.ports.out;

import com.allianceever.portfolio.domain.model.PortfolioSettings;

import java.util.Optional;

/**
 * Port for fetching portfolio settings from the Parameter microservice.
 */
public interface ParameterClientPort {

    Optional<PortfolioSettings> fetchPortfolioSettings();
}
