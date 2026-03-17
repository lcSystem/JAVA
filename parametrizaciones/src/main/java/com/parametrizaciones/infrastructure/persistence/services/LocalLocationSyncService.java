package com.parametrizaciones.infrastructure.persistence.services;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.parametrizaciones.infrastructure.persistence.repository.CatalogItemRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import com.parametrizaciones.infrastructure.messaging.config.RabbitMQConfig;

import java.io.InputStream;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class LocalLocationSyncService {

    private final CatalogItemRepository catalogItemRepository;
    private final ObjectMapper objectMapper;
    private final RabbitTemplate rabbitTemplate;

    @jakarta.annotation.PostConstruct
    public void onStartup() {
        log.info("Triggering Local Location Sync on startup for verification...");
        verifyLocalLocationData();
    }

    // Ejecutar a medianoche (00:00) el dia 1 de cada mes
    @Scheduled(cron = "0 0 0 1 * ?")
    public void verifyLocalLocationData() {
        log.info("Starting monthly verification of Location Data (Departments and Cities)...");

        try {
            ClassPathResource resource = new ClassPathResource("data/colombia_cities.json");

            if (!resource.exists()) {
                log.error("Local data file not found: data/colombia_cities.json");
                return;
            }

            try (InputStream is = resource.getInputStream()) {
                List<Map<String, Object>> jsonData = objectMapper.readValue(is,
                        new TypeReference<List<Map<String, Object>>>() {
                        });

                Set<String> uniqueDepartments = new HashSet<>();
                Set<String> uniqueCities = new HashSet<>();

                for (Map<String, Object> row : jsonData) {
                    if (row.containsKey("cod_dpto")) {
                        uniqueDepartments.add(String.valueOf(row.get("cod_dpto")));
                    }
                    if (row.containsKey("cod_mpio")) {
                        uniqueCities.add(String.valueOf(row.get("cod_mpio")));
                    }
                }

                int localDeptCount = uniqueDepartments.size();
                int localCityCount = uniqueCities.size();

                log.info("Local JSON parsed: {} unique departments, {} unique cities.", localDeptCount, localCityCount);

                long dbDeptCount = catalogItemRepository.countByCatalogCode("DEPARTMENT");
                long dbCityCount = catalogItemRepository.countByCatalogCode("CITY");

                log.info("Database records: {} departments, {} cities.", dbDeptCount, dbCityCount);

                if (localDeptCount != dbDeptCount || localCityCount != dbCityCount) {
                    String alertMessage = String.format(
                            "Location Data Discrepancy Detected! DB has (Depts: %d, Cities: %d), " +
                                    "but Local JSON has (Depts: %d, Cities: %d). A manual synchronization might " +
                                    "be required to match DANE DIVIPOLA data.",
                            dbDeptCount, dbCityCount, localDeptCount, localCityCount);

                    log.warn("===============================================================");
                    log.warn("🚨 {}", alertMessage);
                    log.warn("===============================================================");

                    // Send an alert via RabbitMQ for other microservices (like
                    // notification-service) to pick up
                    sendAlert(alertMessage);
                } else {
                    log.info("Location Data Verification successful. Local JSON and Database are in sync.");
                }
            }

        } catch (Exception e) {
            log.error("Error during monthly location data verification", e);
        }
    }

    private void sendAlert(String payload) {
        try {
            // Routing key could be anything configured in notification-service
            rabbitTemplate.convertAndSend(RabbitMQConfig.EXCHANGE_NAME, "system.alert.location_sync", payload);
        } catch (Exception e) {
            log.error("Failed to push alert to RabbitMQ", e);
        }
    }
}
