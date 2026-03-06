package com.customer.infrastructure.adapter.in.rest;

import com.customer.domain.model.Customer;
import com.customer.domain.model.CustomerHistory;
import com.customer.domain.model.CustomerNote;
import com.customer.domain.ports.in.*;
import com.customer.infrastructure.adapter.in.rest.dto.*;
import com.customer.infrastructure.mapper.CustomerMapper;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/customers")
@RequiredArgsConstructor
public class CustomerController {

    private final CreateCustomerUseCase createCustomerUseCase;
    private final UpdateCustomerUseCase updateCustomerUseCase;
    private final GetCustomerUseCase getCustomerUseCase;
    private final ListCustomersUseCase listCustomersUseCase;
    private final DeleteCustomerUseCase deleteCustomerUseCase;
    private final SearchCustomerByDocumentUseCase searchCustomerByDocumentUseCase;
    private final ManageCustomerNotesUseCase manageCustomerNotesUseCase;
    private final GetCustomerHistoryUseCase getCustomerHistoryUseCase;
    private final CustomerMapper mapper;

    @PostMapping
    @PreAuthorize("hasAuthority('CLIENTES_CREATE')")
    public ResponseEntity<CustomerResponse> create(@Valid @RequestBody CreateCustomerRequest request) {
        Customer customer = mapper.toDomain(request);
        Customer created = createCustomerUseCase.create(customer);
        return new ResponseEntity<>(mapper.toResponse(created), HttpStatus.CREATED);
    }

    @GetMapping
    @PreAuthorize("hasAuthority('CLIENTES_READ')")
    public ResponseEntity<Page<CustomerResponse>> list(Pageable pageable) {
        Page<CustomerResponse> responses = listCustomersUseCase.findAll(pageable)
                .map(mapper::toResponse);
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('CLIENTES_READ')")
    public ResponseEntity<CustomerResponse> getById(@PathVariable Long id) {
        Customer customer = getCustomerUseCase.getById(id);
        return ResponseEntity.ok(mapper.toResponse(customer));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('CLIENTES_UPDATE')")
    public ResponseEntity<CustomerResponse> update(@PathVariable Long id,
            @Valid @RequestBody UpdateCustomerRequest request) {
        request.setId(id);
        Customer customer = mapper.toDomain(request);
        Customer updated = updateCustomerUseCase.update(customer);
        return ResponseEntity.ok(mapper.toResponse(updated));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('CLIENTES_DELETE')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        deleteCustomerUseCase.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/search")
    @PreAuthorize("hasAuthority('CLIENTES_READ')")
    public ResponseEntity<CustomerResponse> searchByDocument(@RequestParam String document) {
        return searchCustomerByDocumentUseCase.findByDocumentNumber(document)
                .map(mapper::toResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Notes
    @GetMapping("/{id}/notes")
    @PreAuthorize("hasAuthority('CLIENTES_READ')")
    public ResponseEntity<List<CustomerNoteDto>> getNotes(@PathVariable Long id) {
        List<CustomerNoteDto> notes = manageCustomerNotesUseCase.getNotes(id)
                .stream()
                .map(mapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(notes);
    }

    @PostMapping("/{id}/notes")
    @PreAuthorize("hasAuthority('CLIENTES_UPDATE')")
    public ResponseEntity<CustomerNoteDto> addNote(@PathVariable Long id, @RequestBody String note) {
        CustomerNote added = manageCustomerNotesUseCase.addNote(id, note);
        return new ResponseEntity<>(mapper.toDto(added), HttpStatus.CREATED);
    }

    // History
    @GetMapping("/{id}/history")
    @PreAuthorize("hasAuthority('CLIENTES_READ')")
    public ResponseEntity<List<CustomerHistoryDto>> getHistory(@PathVariable Long id) {
        List<CustomerHistoryDto> history = getCustomerHistoryUseCase.getHistory(id)
                .stream()
                .map(mapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(history);
    }
}
