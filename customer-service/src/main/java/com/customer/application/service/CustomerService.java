package com.customer.application.service;

import com.customer.domain.model.*;
import com.customer.domain.ports.in.*;
import com.customer.domain.ports.out.CustomerRepositoryPort;
import com.customer.domain.ports.out.EventPublisherPort;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CustomerService implements
        CreateCustomerUseCase,
        UpdateCustomerUseCase,
        GetCustomerUseCase,
        ListCustomersUseCase,
        DeleteCustomerUseCase,
        SearchCustomerByDocumentUseCase,
        ManageCustomerNotesUseCase,
        GetCustomerHistoryUseCase {

    private final CustomerRepositoryPort customerRepository;
    private final EventPublisherPort eventPublisher;

    @Override
    @Transactional
    public Customer create(Customer customer) {
        customer.setStatus(CustomerStatus.ACTIVE);
        Customer saved = customerRepository.save(customer);
        logEvent(saved.getId(), "CREATE", "Cliente creado portal ERP");
        eventPublisher.publishCustomerCreated(saved.getId());
        return saved;
    }

    @Override
    @Transactional
    public Customer update(Customer customer) {
        try {
            Customer updated = customerRepository.save(customer);
            logEvent(updated.getId(), "UPDATE", "Información de cliente actualizada");
            eventPublisher.publishCustomerUpdated(updated.getId());
            return updated;
        } catch (Exception e) {
            System.err.println("ERROR UPDATING CUSTOMER: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Customer getById(Long id) {
        return customerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cliente con ID " + id + " no encontrado"));
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Customer> findAll(Pageable pageable) {
        return customerRepository.findAll(pageable);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Customer customer = getById(id);
        customer.setStatus(CustomerStatus.DELETED);
        customerRepository.save(customer);
        logEvent(id, "DELETE", "Borrado lógico de cliente realizado");
        eventPublisher.publishCustomerDeleted(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Customer> findByDocumentNumber(String documentNumber) {
        return customerRepository.findByDocumentNumber(documentNumber);
    }

    // Notes Implementation
    @Override
    @Transactional
    public CustomerNote addNote(Long customerId, String noteText) {
        CustomerNote note = CustomerNote.builder()
                .customerId(customerId)
                .note(noteText)
                .build();
        CustomerNote saved = customerRepository.saveNote(note);
        logEvent(customerId, "ADD_NOTE", "Nota agregada al expediente");
        return saved;
    }

    @Override
    @Transactional(readOnly = true)
    public List<CustomerNote> getNotes(Long customerId) {
        return customerRepository.findNotesByCustomerId(customerId);
    }

    @Override
    @Transactional
    public void deleteNote(Long customerId, Long noteId) {
        customerRepository.findNoteById(noteId).ifPresent(note -> {
            customerRepository.deleteNote(noteId);
            logEvent(customerId, "DELETE_NOTE", "Nota interna eliminada: " + note.getNote());
        });
    }

    // History Implementation
    @Override
    @Transactional(readOnly = true)
    public List<CustomerHistory> getHistory(Long customerId) {
        return customerRepository.findHistoryByCustomerId(customerId);
    }

    @Override
    @Transactional
    public void logEvent(Long customerId, String eventType, String description) {
        List<CustomerHistory> existingHistory = customerRepository.findHistoryByCustomerId(customerId);
        if (existingHistory.size() >= 100) {
            existingHistory.stream()
                    .sorted(Comparator.comparing(CustomerHistory::getCreatedAt))
                    .limit(existingHistory.size() - 99)
                    .forEach(h -> customerRepository.deleteHistoryById(h.getId()));
        }

        CustomerHistory history = CustomerHistory.builder()
                .customerId(customerId)
                .eventType(eventType)
                .description(description)
                .build();
        customerRepository.saveHistory(history);
    }
}
