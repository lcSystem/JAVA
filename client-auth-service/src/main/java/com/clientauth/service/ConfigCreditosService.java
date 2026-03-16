package com.clientauth.service;

import com.clientauth.entity.ConfigCreditosEntity;
import com.clientauth.repository.ConfigCreditosRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ConfigCreditosService {

    private final ConfigCreditosRepository configRepo;

    /**
     * Get all design configuration as a key-value map.
     * This is consumed by the Flutter app at startup.
     */
    public Map<String, String> getAllConfig() {
        List<ConfigCreditosEntity> configs = configRepo.findAll();
        Map<String, String> result = new LinkedHashMap<>();
        for (ConfigCreditosEntity config : configs) {
            result.put(config.getConfigKey(), config.getConfigValue());
        }
        return result;
    }

    /**
     * Get a specific config value by key.
     */
    public String getConfigByKey(String key) {
        return configRepo.findByConfigKey(key)
                .map(ConfigCreditosEntity::getConfigValue)
                .orElse(null);
    }

    /**
     * Update a config value. Used by admin panel.
     */
    public void updateConfig(String key, String value) {
        ConfigCreditosEntity config = configRepo.findByConfigKey(key)
                .orElseThrow(() -> new RuntimeException("Config key not found: " + key));
        config.setConfigValue(value);
        config.setUpdatedAt(java.time.LocalDateTime.now());
        configRepo.save(config);
    }
}
