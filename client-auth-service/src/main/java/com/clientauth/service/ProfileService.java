package com.clientauth.service;

import com.clientauth.dto.CustomerAddressResponse;
import com.clientauth.dto.CustomerContactResponse;
import com.clientauth.dto.CustomerProfileResponse;
import com.clientauth.dto.ProfileUpdateRequest;
import com.clientauth.entity.CustomerAuthEntity;
import com.clientauth.exception.InvalidCredentialsException;
import com.clientauth.repository.CustomerAuthRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.clientauth.entity.CustomerAddressEntity;
import com.clientauth.entity.CustomerContactEntity;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProfileService {

    private final CustomerAuthRepository customerRepo;

    /**
     * Get customer profile by customer ID.
     */
    public CustomerProfileResponse getProfile(Long customerId) {
        CustomerAuthEntity customer = customerRepo.findByIdWithDetails(customerId)
                .orElseThrow(() -> new InvalidCredentialsException("Cliente no encontrado"));

        return toProfileResponse(customer);
    }

    /**
     * Update customer profile. Only non-null fields are updated.
     * Clients cannot delete information, only edit it.
     */
    @Transactional
    public CustomerProfileResponse updateProfile(Long customerId, ProfileUpdateRequest request) {
        CustomerAuthEntity customer = customerRepo.findByIdWithDetails(customerId)
                .orElseThrow(() -> new InvalidCredentialsException("Cliente no encontrado"));

        // Basic Info
        if (request.getName() != null && !request.getName().isBlank()) {
            customer.setName(request.getName());
        }
        if (request.getEmail() != null && !request.getEmail().isBlank()) {
            customer.setEmail(request.getEmail());
        }
        if (request.getPhone() != null && !request.getPhone().isBlank()) {
            customer.setPhone(request.getPhone());
        }

        // Addresses
        if (request.getAddresses() != null) {
            if (customer.getAddresses() == null) {
                customer.setAddresses(new HashSet<>());
            }
            for (CustomerAddressResponse addrReq : request.getAddresses()) {
                if (addrReq.getId() == null) {
                    // New Address
                    customer.getAddresses().add(CustomerAddressEntity.builder()
                            .customer(customer)
                            .street(addrReq.getStreet())
                            .city(addrReq.getCity())
                            .state(addrReq.getState())
                            .country(addrReq.getCountry())
                            .postalCode(addrReq.getPostalCode())
                            .type(addrReq.getType())
                            .build());
                } else {
                    // Update Existing (only if it belongs to the customer)
                    customer.getAddresses().stream()
                            .filter(a -> a.getId().equals(addrReq.getId()))
                            .findFirst()
                            .ifPresent(a -> {
                                a.setStreet(addrReq.getStreet());
                                a.setCity(addrReq.getCity());
                                a.setState(addrReq.getState());
                                a.setCountry(addrReq.getCountry());
                                a.setPostalCode(addrReq.getPostalCode());
                                a.setType(addrReq.getType());
                            });
                }
            }
        }

        // Contacts
        if (request.getContacts() != null) {
            if (customer.getContacts() == null) {
                customer.setContacts(new HashSet<>());
            }
            for (CustomerContactResponse contReq : request.getContacts()) {
                if (contReq.getId() == null) {
                    // New Contact
                    customer.getContacts().add(CustomerContactEntity.builder()
                            .customer(customer)
                            .name(contReq.getName())
                            .phone(contReq.getPhone())
                            .email(contReq.getEmail())
                            .position(contReq.getPosition())
                            .documentNumber(contReq.getDocumentNumber())
                            .birthDate(contReq.getBirthDate())
                            .isLegalRepresentative(contReq.getIsLegalRepresentative())
                            .build());
                } else {
                    // Update Existing
                    customer.getContacts().stream()
                            .filter(c -> c.getId().equals(contReq.getId()))
                            .findFirst()
                            .ifPresent(c -> {
                                c.setName(contReq.getName());
                                c.setPhone(contReq.getPhone());
                                c.setEmail(contReq.getEmail());
                                c.setPosition(contReq.getPosition());
                                c.setDocumentNumber(contReq.getDocumentNumber());
                                c.setBirthDate(contReq.getBirthDate());
                                c.setIsLegalRepresentative(contReq.getIsLegalRepresentative());
                            });
                }
            }
        }

        customer.setUpdatedAt(java.time.LocalDateTime.now());
        customerRepo.save(customer);

        return toProfileResponse(customer);
    }

    private CustomerProfileResponse toProfileResponse(CustomerAuthEntity customer) {
        return CustomerProfileResponse.builder()
                .id(customer.getId())
                .name(customer.getName())
                .documentNumber(customer.getDocumentNumber())
                .email(customer.getEmail())
                .phone(customer.getPhone())
                .type(customer.getType())
                .status(customer.getStatus())
                .addresses(customer.getAddresses() != null ? customer.getAddresses().stream()
                        .map(addr -> CustomerAddressResponse.builder()
                                .id(addr.getId())
                                .street(addr.getStreet())
                                .city(addr.getCity())
                                .state(addr.getState())
                                .country(addr.getCountry())
                                .postalCode(addr.getPostalCode())
                                .type(addr.getType())
                                .build())
                        .collect(Collectors.toList()) : null)
                .contacts(customer.getContacts() != null ? customer.getContacts().stream()
                        .map(contact -> CustomerContactResponse.builder()
                                .id(contact.getId())
                                .name(contact.getName())
                                .phone(contact.getPhone())
                                .email(contact.getEmail())
                                .position(contact.getPosition())
                                .documentNumber(contact.getDocumentNumber())
                                .birthDate(contact.getBirthDate())
                                .isLegalRepresentative(contact.getIsLegalRepresentative())
                                .build())
                        .collect(Collectors.toList()) : null)
                .build();
    }
}
