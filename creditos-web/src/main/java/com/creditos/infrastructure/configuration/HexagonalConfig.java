package com.creditos.infrastructure.configuration;

import com.creditos.application.services.CreditRequestUseCaseImpl;
import com.creditos.domain.ports.in.CreditRequestUseCase;
import com.creditos.domain.ports.out.CreditRequestRepositoryPort;
import com.creditos.domain.ports.out.CreditTypeRepositoryPort;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class HexagonalConfig {

    @Bean
    public CreditRequestUseCase creditRequestUseCase(
            CreditRequestRepositoryPort creditRequestRepositoryPort,
            CreditTypeRepositoryPort creditTypeRepositoryPort,
            com.creditos.domain.ports.in.ScoringUseCase scoringUseCase,
            com.creditos.domain.ports.in.AmortizationUseCase amortizationUseCase) {
        return new CreditRequestUseCaseImpl(creditRequestRepositoryPort, creditTypeRepositoryPort, scoringUseCase,
                amortizationUseCase);
    }
}
