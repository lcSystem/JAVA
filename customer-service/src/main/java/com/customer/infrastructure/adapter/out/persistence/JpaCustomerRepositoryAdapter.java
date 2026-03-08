package com.customer.infrastructure.adapter.out.persistence;

import com.customer.domain.model.Customer;
import com.customer.domain.model.CustomerHistory;
import com.customer.domain.model.CustomerNote;
import com.customer.domain.ports.out.CustomerRepositoryPort;
import com.customer.infrastructure.mapper.CustomerMapper;
import com.customer.infrastructure.persistence.entity.CustomerEntity;
import com.customer.infrastructure.persistence.entity.CustomerHistoryEntity;
import com.customer.infrastructure.persistence.entity.CustomerNoteEntity;
import com.customer.infrastructure.persistence.repository.SpringDataCustomerHistoryRepository;
import com.customer.infrastructure.persistence.repository.SpringDataCustomerNoteRepository;
import com.customer.infrastructure.persistence.repository.SpringDataCustomerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaCustomerRepositoryAdapter implements CustomerRepositoryPort {

    private final SpringDataCustomerRepository repository;
    private final SpringDataCustomerNoteRepository noteRepository;
    private final SpringDataCustomerHistoryRepository historyRepository;
    private final CustomerMapper mapper;

    @Override
    public Customer save(Customer customer) {
        CustomerEntity entity = mapper.toEntity(customer);
        CustomerEntity savedEntity = repository.save(entity);
        return mapper.toDomain(savedEntity);
    }

    @Override
    public Optional<Customer> findById(Long id) {
        return repository.findById(id).map(mapper::toDomain);
    }

    @Override
    public Page<Customer> findAll(Pageable pageable) {
        return repository.findAll(pageable).map(mapper::toDomain);
    }

    @Override
    public void delete(Long id) {
        repository.deleteById(id);
    }

    @Override
    public Optional<Customer> findByDocumentNumber(String documentNumber) {
        return repository.findByDocumentNumber(documentNumber).map(mapper::toDomain);
    }

    @Override
    public CustomerNote saveNote(CustomerNote note) {
        CustomerNoteEntity entity = mapper.toEntity(note);
        // Ensure customer entity is attached if needed, or use ID directly
        if (note.getCustomerId() != null) {
            CustomerEntity customer = new CustomerEntity();
            customer.setId(note.getCustomerId());
            entity.setCustomer(customer);
        }
        CustomerNoteEntity saved = noteRepository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public List<CustomerNote> findNotesByCustomerId(Long customerId) {
        return noteRepository.findByCustomerIdOrderByCreatedAtDesc(customerId)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<CustomerNote> findNoteById(Long noteId) {
        return noteRepository.findById(noteId).map(mapper::toDomain);
    }

    @Override
    public void deleteNote(Long noteId) {
        noteRepository.deleteById(noteId);
    }

    @Override
    public CustomerHistory saveHistory(CustomerHistory history) {
        CustomerHistoryEntity entity = mapper.toEntity(history);
        if (history.getCustomerId() != null) {
            CustomerEntity customer = new CustomerEntity();
            customer.setId(history.getCustomerId());
            entity.setCustomer(customer);
        }
        CustomerHistoryEntity saved = historyRepository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public List<CustomerHistory> findHistoryByCustomerId(Long customerId) {
        return historyRepository.findByCustomerIdOrderByCreatedAtDesc(customerId)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteHistoryById(Long id) {
        historyRepository.deleteById(id);
    }
}
