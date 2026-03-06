package com.customer.domain.ports.out;

import com.customer.domain.model.Customer;
import com.customer.domain.model.CustomerHistory;
import com.customer.domain.model.CustomerNote;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

public interface CustomerRepositoryPort {
    Customer save(Customer customer);

    Optional<Customer> findById(Long id);

    Page<Customer> findAll(Pageable pageable);

    void delete(Long id);

    Optional<Customer> findByDocumentNumber(String documentNumber);

    // Notes
    CustomerNote saveNote(CustomerNote note);

    List<CustomerNote> findNotesByCustomerId(Long customerId);

    // History
    CustomerHistory saveHistory(CustomerHistory history);

    List<CustomerHistory> findHistoryByCustomerId(Long customerId);
}
