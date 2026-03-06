package com.customer.domain.ports.in;

import com.customer.domain.model.Customer;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ListCustomersUseCase {
    Page<Customer> findAll(Pageable pageable);
}
