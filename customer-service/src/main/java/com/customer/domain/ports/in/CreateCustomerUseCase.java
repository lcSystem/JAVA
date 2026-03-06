package com.customer.domain.ports.in;

import com.customer.domain.model.Customer;

public interface CreateCustomerUseCase {
    Customer create(Customer customer);
}
