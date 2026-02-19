package com.allianceever.projectERP.AuthenticatedBackend.infrastructure.configuration;

import com.allianceever.projectERP.AuthenticatedBackend.application.services.ManageUserUseCaseImpl;
import com.allianceever.projectERP.AuthenticatedBackend.domain.ports.in.ManageUserUseCase;
import com.allianceever.projectERP.AuthenticatedBackend.domain.ports.out.UserRepositoryPort;
import com.allianceever.projectERP.AuthenticatedBackend.domain.ports.out.SecurityPort;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class HexagonalArchitectureConfig {

    @Bean
    public ManageUserUseCase manageUserUseCase(UserRepositoryPort userRepositoryPort, SecurityPort securityPort) {
        return new ManageUserUseCaseImpl(userRepositoryPort, securityPort);
    }
}
