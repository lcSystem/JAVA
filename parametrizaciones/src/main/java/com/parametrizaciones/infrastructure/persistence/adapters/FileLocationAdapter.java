package com.parametrizaciones.infrastructure.persistence.adapters;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.io.InputStream;
import java.util.*;

@Slf4j
@Component
@RequiredArgsConstructor
public class FileLocationAdapter {

    private final ObjectMapper objectMapper;

    // Cache of Department Code -> Department Info (which contains a list of Cities)
    @Getter
    private List<DepartmentDto> cachedLocations = new ArrayList<>();

    private Map<String, DepartmentDto> departmentMap = new HashMap<>();
    private Map<String, String> cityToDepartmentMap = new HashMap<>(); // cityCode -> deptCode

    @PostConstruct
    public void init() {
        loadDataFromFile();
    }

    private void loadDataFromFile() {
        try {
            ClassPathResource resource = new ClassPathResource("data/colombia_cities.json");
            if (!resource.exists()) {
                log.error("colombia_cities.json not found in classpath.");
                return;
            }

            try (InputStream is = resource.getInputStream()) {
                List<Map<String, Object>> jsonData = objectMapper.readValue(is, new TypeReference<>() {
                });

                Map<String, DepartmentDto> tempDeptMap = new LinkedHashMap<>();

                for (Map<String, Object> row : jsonData) {
                    String dptoCode = row.containsKey("cod_dpto") ? String.valueOf(row.get("cod_dpto")) : null;
                    String cityCode = row.containsKey("cod_mpio") ? String.valueOf(row.get("cod_mpio")) : null;

                    if (dptoCode == null || cityCode == null)
                        continue;

                    String dptoNameRaw = String.valueOf(row.get("dpto")).toUpperCase();
                    if (dptoNameRaw.equals("BOGOTÁ, D.C."))
                        dptoNameRaw = "Bogotá, D.C.";
                    final String dptoName = dptoNameRaw;

                    String cityNameRaw = String.valueOf(row.get("nom_mpio")).toUpperCase();
                    if (cityNameRaw.equals("BOGOTÁ, D.C."))
                        cityNameRaw = "Bogotá, D.C.";
                    final String cityName = cityNameRaw;

                    DepartmentDto deptDto = tempDeptMap.computeIfAbsent(dptoCode,
                            k -> new DepartmentDto(dptoCode, dptoName, new ArrayList<>()));

                    CityDto cityDto = new CityDto(cityCode, cityName);
                    // Avoid duplicates if the JSON has any
                    if (deptDto.getCities().stream().noneMatch(c -> c.getCode().equals(cityCode))) {
                        deptDto.getCities().add(cityDto);
                        cityToDepartmentMap.put(cityCode, dptoCode);
                    }
                }

                // Sort departments alphabetically
                List<DepartmentDto> sortedDepts = new ArrayList<>(tempDeptMap.values());
                sortedDepts.sort(Comparator.comparing(DepartmentDto::getName));

                // Sort cities alphabetically within departments
                for (DepartmentDto dept : sortedDepts) {
                    dept.getCities().sort(Comparator.comparing(CityDto::getName));
                }

                this.cachedLocations = sortedDepts;
                this.departmentMap = tempDeptMap;
                log.info("Loaded {} departments and their cities from local JSON file.", sortedDepts.size());
            }

        } catch (Exception e) {
            log.error("Failed to load local location data: {}", e.getMessage());
        }
    }

    public boolean validateLocation(String departmentCode, String cityCode) {
        if (departmentCode == null || cityCode == null)
            return false;

        DepartmentDto dept = departmentMap.get(departmentCode);
        if (dept == null)
            return false;

        return dept.getCities().stream().anyMatch(c -> c.getCode().equals(cityCode));
    }

    // DTO records for the cached data
    @Getter
    @RequiredArgsConstructor
    public static class DepartmentDto {
        private final String code;
        private final String name;
        private final List<CityDto> cities;
    }

    @Getter
    @RequiredArgsConstructor
    public static class CityDto {
        private final String code;
        private final String name;
    }
}
