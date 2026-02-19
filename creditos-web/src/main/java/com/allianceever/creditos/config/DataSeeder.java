package com.allianceever.creditos.config;

import com.allianceever.creditos.model.ApplicantProfile;
import com.allianceever.creditos.repository.ApplicantProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.math.BigDecimal;

@Configuration
@RequiredArgsConstructor
public class DataSeeder {

    private final ApplicantProfileRepository applicantProfileRepository;

    @Bean
    public CommandLineRunner initData() {
        return args -> {
            // Seed a sample applicant profile for user 2 (which is usually the admin/sample
            // user)
            if (applicantProfileRepository.findByUserId(2L).isEmpty()) {
                applicantProfileRepository.save(ApplicantProfile.builder()
                        .userId(2L)
                        .monthlyIncome(new BigDecimal("5000.00"))
                        .monthlyExpenses(new BigDecimal("2000.00"))
                        .currentDebts(new BigDecimal("500.00"))
                        .creditScore(750)
                        .build());
            }
        };
    }
}
