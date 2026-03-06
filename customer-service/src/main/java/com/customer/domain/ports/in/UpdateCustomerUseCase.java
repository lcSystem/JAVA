package com.customer.domain.ports.in;

import com.customer.domain.model.Customer;

public interface UpdateCustomerUseCase {
    Customer update(Customer customer);
}
