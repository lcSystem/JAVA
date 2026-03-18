package com.parametrizaciones.infrastructure.persistence.services;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.parametrizaciones.infrastructure.persistence.entities.CatalogItemJpaEntity;
import com.parametrizaciones.infrastructure.persistence.repository.CatalogItemRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import com.parametrizaciones.infrastructure.messaging.config.RabbitMQConfig;

import java.io.InputStream;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class LocalLocationSyncService {

    private final CatalogItemRepository catalogItemRepository;
    private final ObjectMapper objectMapper;
    private final RabbitTemplate rabbitTemplate;

    @jakarta.annotation.PostConstruct
    public void onStartup() {
        log.info("Triggering Local Location Sync on startup for integration verification...");
        verifyLocalLocationData();
    }

    // Ejecutar a medianoche (00:00) el dia 1 de cada mes
    @Scheduled(cron = "0 0 0 1 * ?")
    public void verifyLocalLocationData() {
        log.info("Starting integration verification of Location Data (Departments and Cities) from local JSON...");

        try {
            ClassPathResource resource = new ClassPathResource("data/colombia_cities.json");

            if (!resource.exists()) {
                log.error("Local data file not found: data/colombia_cities.json");
                return;
            }

            // 1. Get Country CO
            Optional<CatalogItemJpaEntity> countryOpt = catalogItemRepository.findByCatalogCodeAndCode("COUNTRY", "CO");
            if (countryOpt.isEmpty()) {
                log.error("Country 'CO' not found in database. Cannot integrate locations.");
                return;
            }
            Long countryId = countryOpt.get().getId();

            try (InputStream is = resource.getInputStream()) {
                List<Map<String, Object>> jsonData = objectMapper.readValue(is,
                        new TypeReference<List<Map<String, Object>>>() {
                        });

                // 2. Pre-fetch existing Departments and Cities into Maps for fast lookup
                List<CatalogItemJpaEntity> existingDepts = catalogItemRepository
                        .findByCatalogCodeAndCompanyIdIsNullAndEnabledTrueOrderByOrderIndexAsc("DEPARTMENT");
                Map<String, CatalogItemJpaEntity> deptMap = existingDepts.stream()
                        .collect(Collectors.toMap(CatalogItemJpaEntity::getCode, Function.identity(), (a, b) -> a));

                List<CatalogItemJpaEntity> existingCities = catalogItemRepository
                        .findByCatalogCodeAndCompanyIdIsNullAndEnabledTrueOrderByOrderIndexAsc("CITY");
                Map<String, CatalogItemJpaEntity> cityMap = existingCities.stream()
                        .collect(Collectors.toMap(CatalogItemJpaEntity::getCode, Function.identity(), (a, b) -> a));

                // 3. Process the JSON data
                int newDeptsCount = 0;
                int newCitiesCount = 0;

                // Dedup collections
                Map<String, Map<String, Object>> uniqueDeptsFromJson = new LinkedHashMap<>();
                Map<String, Map<String, Object>> uniqueCitiesFromJson = new LinkedHashMap<>();

                for (Map<String, Object> row : jsonData) {
                    String dptoCode = row.containsKey("cod_dpto") ? String.valueOf(row.get("cod_dpto")) : null;
                    String cityCode = row.containsKey("cod_mpio") ? String.valueOf(row.get("cod_mpio")) : null;

                    if (dptoCode != null && !uniqueDeptsFromJson.containsKey(dptoCode)) {
                        uniqueDeptsFromJson.put(dptoCode, row);
                    }
                    if (cityCode != null && dptoCode != null && !uniqueCitiesFromJson.containsKey(cityCode)) {
                        uniqueCitiesFromJson.put(cityCode, row);
                    }
                }

                // Insert missing Departments
                int deptOrder = deptMap.size() + 1;
                for (Map.Entry<String, Map<String, Object>> entry : uniqueDeptsFromJson.entrySet()) {
                    String code = entry.getKey();
                    if (!deptMap.containsKey(code)) {
                        String name = String.valueOf(entry.getValue().get("dpto")).toUpperCase();
                        if (name.equals("BOGOTÁ, D.C."))
                            name = "Bogotá, D.C.";

                        String extra = String.format("{\"daneCode\": \"%s\"}", code);

                        CatalogItemJpaEntity newDept = CatalogItemJpaEntity.builder()
                                .catalogCode("DEPARTMENT")
                                .code(code)
                                .name(name)
                                .parentId(countryId)
                                .orderIndex(deptOrder++)
                                .extraData(extra)
                                .enabled(true)
                                .build();

                        log.info("Inserting new Department: {} - {}", code, name);
                        newDept = catalogItemRepository.save(newDept);
                        deptMap.put(code, newDept);
                        newDeptsCount++;
                    }
                }

                // Insert missing Cities
                int cityOrder = cityMap.size() + 1;
                for (Map.Entry<String, Map<String, Object>> entry : uniqueCitiesFromJson.entrySet()) {
                    String code = entry.getKey();
                    if (!cityMap.containsKey(code)) {
                        Map<String, Object> row = entry.getValue();
                        String name = String.valueOf(row.get("nom_mpio")).toUpperCase();
                        if (name.equals("BOGOTÁ, D.C."))
                            name = "Bogotá, D.C.";
                        String deptCode = String.valueOf(row.get("cod_dpto"));

                        CatalogItemJpaEntity parentDept = deptMap.get(deptCode);
                        if (parentDept == null)
                            continue; // Should not happen

                        String latStr = row.containsKey("latitud")
                                ? String.valueOf(row.get("latitud")).replace(",", ".")
                                : "0";
                        String lngStr = row.containsKey("longitud")
                                ? String.valueOf(row.get("longitud")).replace(",", ".")
                                : "0";

                        double lat = 0.0, lng = 0.0;
                        try {
                            lat = Double.parseDouble(latStr);
                            lng = Double.parseDouble(lngStr);
                        } catch (Exception ignored) {
                        }

                        String extra = String.format("{\"daneCode\": \"%s\", \"latitude\": %.6f, \"longitude\": %.6f}",
                                code, lat, lng);
                        extra = extra.replace(',', '.'); // Ensure period for decimals in JSON

                        CatalogItemJpaEntity newCity = CatalogItemJpaEntity.builder()
                                .catalogCode("CITY")
                                .code(code)
                                .name(name)
                                .parentId(parentDept.getId())
                                .orderIndex(cityOrder++)
                                .extraData(extra)
                                .enabled(true)
                                .build();

                        newCity = catalogItemRepository.save(newCity);
                        cityMap.put(code, newCity);
                        newCitiesCount++;
                    }
                }

                log.info("Local Location Integration completed. Inserted {} missing departments and {} missing cities.",
                        newDeptsCount, newCitiesCount);

                if (newDeptsCount > 0 || newCitiesCount > 0) {
                    String alertMessage = String.format(
                            "Location Data Auto-Integrated! Added %d departments and %d cities.", newDeptsCount,
                            newCitiesCount);
                    sendAlert(alertMessage);
                }
            }

        } catch (Exception e) {
            log.error("Error during monthly location data integration", e);
        }
    }

    private void sendAlert(String payload) {
        try {
            rabbitTemplate.convertAndSend(RabbitMQConfig.EXCHANGE_NAME, "system.alert.location_sync", payload);
        } catch (Exception e) {
            log.error("Failed to push alert to RabbitMQ", e);
        }
    }
}
