package com.customer.infrastructure.mapper;

import com.customer.domain.model.*;
import com.customer.infrastructure.adapter.in.rest.dto.*;
import com.customer.infrastructure.persistence.entity.*;
import org.mapstruct.AfterMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

@Mapper(componentModel = "spring")
public interface CustomerMapper {

    @Mapping(target = "notes", ignore = true)
    @Mapping(target = "history", ignore = true)
    Customer toDomain(CustomerEntity entity);

    @Named("toDomainNoRelationships")
    @Mapping(target = "addresses", ignore = true)
    @Mapping(target = "contacts", ignore = true)
    @Mapping(target = "notes", ignore = true)
    @Mapping(target = "history", ignore = true)
    Customer toDomainNoRelationships(CustomerEntity entity);

    @Mapping(target = "notes", ignore = true)
    @Mapping(target = "history", ignore = true)
    CustomerEntity toEntity(Customer domain);

    @AfterMapping
    default void linkRelationships(@MappingTarget CustomerEntity entity) {
        if (entity.getAddresses() != null) {
            entity.getAddresses().forEach(address -> address.setCustomer(entity));
        }
        if (entity.getContacts() != null) {
            entity.getContacts().forEach(contact -> contact.setCustomer(entity));
        }
        if (entity.getNotes() != null) {
            entity.getNotes().forEach(note -> note.setCustomer(entity));
        }
        if (entity.getHistory() != null) {
            entity.getHistory().forEach(h -> h.setCustomer(entity));
        }
    }

    @Mapping(target = "customerId", source = "customer.id")
    CustomerAddress toDomain(CustomerAddressEntity entity);

    CustomerAddressEntity toEntity(CustomerAddress domain);

    @Mapping(target = "addressType", source = "type")
    CustomerAddress toDomain(CustomerAddressDto dto);

    @Mapping(target = "type", source = "addressType")
    CustomerAddressDto toDto(CustomerAddress domain);

    @Mapping(target = "customerId", source = "customer.id")
    CustomerContact toDomain(CustomerContactEntity entity);

    CustomerContactEntity toEntity(CustomerContact domain);

    CustomerContact toDomain(CustomerContactDto dto);

    CustomerContactDto toDto(CustomerContact domain);

    CustomerNote toDomain(CustomerNoteEntity entity);

    CustomerNoteEntity toEntity(CustomerNote domain);

    CustomerNote toDomain(CustomerNoteDto dto);

    CustomerNoteDto toDto(CustomerNote domain);

    CustomerHistory toDomain(CustomerHistoryEntity entity);

    CustomerHistoryEntity toEntity(CustomerHistory domain);

    CustomerHistory toDomain(CustomerHistoryDto dto);

    CustomerHistoryDto toDto(CustomerHistory domain);

    @Mapping(target = "notes", ignore = true)
    @Mapping(target = "history", ignore = true)
    Customer toDomain(CreateCustomerRequest request);

    @Mapping(target = "notes", ignore = true)
    @Mapping(target = "history", ignore = true)
    Customer toDomain(UpdateCustomerRequest request);

    CustomerResponse toResponse(Customer domain);
}
