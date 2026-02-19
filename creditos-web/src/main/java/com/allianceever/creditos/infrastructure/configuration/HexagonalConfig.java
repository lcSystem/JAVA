package com.allianceever.creditos.infrastructure.configuration;

import com.allianceever.creditos.application.services.CreditRequestUseCaseImpl;
import com.allianceever.creditos.domain.ports.in.CreditRequestUseCase;
import com.allianceever.creditos.domain.ports.out.CreditRequestRepositoryPort;
import com.allianceever.creditos.domain.ports.out.CreditTypeRepositoryPort;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class HexagonalConfig {

    @Bean
    public CreditRequestUseCase creditRequestUseCase(
            CreditRequestRepositoryPort creditRequestRepositoryPort,
            CreditTypeRepositoryPort creditTypeRepositoryPort,
            com.allianceever.creditos.domain.ports.in.ScoringUseCase scoringUseCase,
            com.allianceever.creditos.domain.ports.in.AmortizationUseCase amortizationUseCase) {
        return new CreditRequestUseCaseImpl(creditRequestRepositoryPort, creditTypeRepositoryPort, scoringUseCase,
                amortizationUseCase);
    }
}
