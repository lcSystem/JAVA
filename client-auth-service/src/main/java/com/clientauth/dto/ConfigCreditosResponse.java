package com.clientauth.dto;

import lombok.Builder;
import lombok.Data;

import java.util.Map;

@Data
@Builder
public class ConfigCreditosResponse {
    private Map<String, String> config;
}
