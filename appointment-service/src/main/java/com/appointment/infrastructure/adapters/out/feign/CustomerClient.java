package com.appointment.infrastructure.adapters.out.feign;

import java.util.UUID;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

// Note: name should match the registered eureka name for customer-service
@FeignClient(name = "customer-service", path = "/api/customers")
public interface CustomerClient {

    @GetMapping("/{id}/exists")
    boolean checkCustomerExists(@PathVariable("id") UUID id);

    @GetMapping("/{id}/email")
    String getCustomerEmail(@PathVariable("id") UUID id);

    @GetMapping("/{id}/name")
    String getCustomerName(@PathVariable("id") String id);
}
