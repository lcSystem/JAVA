package com.customer.domain.ports.out;

public interface EventPublisherPort {
    void publishCustomerCreated(Long customerId);

    void publishCustomerUpdated(Long customerId);

    void publishCustomerDeleted(Long customerId);
}
