package com.customer.domain.ports.in;

import com.customer.domain.model.Customer;

public interface GetCustomerUseCase {
    Customer getById(Long id);
}
