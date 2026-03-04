package com.notifications.infrastructure.monitoring;

import com.notifications.domain.model.Notification;
import com.notifications.domain.model.NotificationLevel;
import com.notifications.domain.model.NotificationType;
import com.notifications.domain.service.NotificationService;
import jakarta.annotation.PostConstruct;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
public class HealthCheckService {

    private final NotificationService notificationService;
    private final MonitoringProperties properties;
    private final RestTemplate restTemplate = new RestTemplate();
    private final Map<String, ServiceStatus> serviceStates = new HashMap<>();

    private enum ServiceStatus {
        UP, DOWN, UNKNOWN
    }

    @PostConstruct
    public void init() {
        properties.getServices().forEach(s -> serviceStates.put(s.getName(), ServiceStatus.UNKNOWN));
    }

    @Scheduled(fixedDelayString = "${monitoring.check-interval:30000}")
    public void checkHealth() {
        log.info("Starting health check for {} services", properties.getServices().size());

        for (MonitoringProperties.ServiceConfig service : properties.getServices()) {
            ServiceStatus currentStatus = checkService(service.getUrl());
            ServiceStatus previousStatus = serviceStates.get(service.getName());

            if (currentStatus != previousStatus) {
                // If it was UNKNOWN and became DOWN, or if it changed between UP and DOWN
                if ((previousStatus == ServiceStatus.UNKNOWN && currentStatus == ServiceStatus.DOWN) ||
                        (previousStatus != ServiceStatus.UNKNOWN)) {
                    handleStatusChange(service.getName(), previousStatus, currentStatus);
                }
            }

            serviceStates.put(service.getName(), currentStatus);
        }
    }

    private ServiceStatus checkService(String url) {
        try {
            String response = restTemplate.getForObject(url, String.class);
            if (response != null && (response.contains("\"status\":\"UP\"") || response.contains("UP"))) {
                return ServiceStatus.UP;
            }
            return ServiceStatus.DOWN;
        } catch (Exception e) {
            log.warn("Service at {} is unreachable: {}", url, e.getMessage());
            return ServiceStatus.DOWN;
        }
    }

    private void handleStatusChange(String serviceName, ServiceStatus oldStatus, ServiceStatus newStatus) {
        log.info("Service {} changed status from {} to {}", serviceName, oldStatus, newStatus);

        Notification notification = new Notification();
        notification.setUserId("SYSTEM"); // Global system notification
        notification.setType(NotificationType.SERVICE_STATUS);
        notification.setTimestamp(LocalDateTime.now());
        notification.setReadStatus(false);

        if (newStatus == ServiceStatus.DOWN) {
            notification.setLevel(NotificationLevel.ERROR);
            notification.setMessage("ALERTA CRÍTICA: El microservicio [" + serviceName + "] no está respondiendo.");
        } else if (newStatus == ServiceStatus.UP) {
            notification.setLevel(NotificationLevel.SUCCESS);
            notification.setMessage("RESTAURACIÓN: El microservicio [" + serviceName + "] vuelve a estar activo.");
        }

        notificationService.createNotification(notification);
    }

    @Data
    @Configuration
    @ConfigurationProperties(prefix = "monitoring")
    public static class MonitoringProperties {
        private int checkInterval;
        private List<ServiceConfig> services = new ArrayList<>();

        @Data
        public static class ServiceConfig {
            private String name;
            private String url;
        }
    }
}
