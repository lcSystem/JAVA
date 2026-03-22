package com.appointment.infrastructure.adapters.out.feign;

import java.util.UUID;

import org.springframework.stereotype.Component;

import com.appointment.application.ports.out.CustomerServicePort;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class CustomerFeignAdapter implements CustomerServicePort {

    private final CustomerClient customerClient;

    @Override
    public boolean customerExists(UUID customerId) {
        try {
            return customerClient.checkCustomerExists(customerId);
        } catch (Exception e) {
            log.error("Failed to check customer existence via Feign for ID: {}", customerId, e);
            // Defaulting to false if service fails, or rethrow custom exception
            return false;
        }
    }

    @Override
    public String getCustomerEmail(UUID customerId) {
        try {
            return customerClient.getCustomerEmail(customerId);
        } catch (Exception e) {
            log.error("Failed to fetch customer email via Feign for ID: {}", customerId, e);
            return null;
        }
    }

    @Override
    public String getCustomerName(String customerId) {
        try {
            return customerClient.getCustomerName(customerId);
        } catch (Exception e) {
            log.warn("Failed to fetch customer name via Feign for ID: {}. Falling back.", customerId);
            return null;
        }
    }
}
