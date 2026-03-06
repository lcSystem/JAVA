package com.customer.domain.ports.in;

import com.customer.domain.model.Customer;
import java.util.Optional;

public interface SearchCustomerByDocumentUseCase {
    Optional<Customer> findByDocumentNumber(String documentNumber);
}
