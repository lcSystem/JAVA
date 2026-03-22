package com.appointment.application.ports.out;

import java.util.UUID;

public interface CustomerServicePort {
    boolean customerExists(UUID customerId);

    String getCustomerEmail(UUID customerId);

    String getCustomerName(String customerId);
}
