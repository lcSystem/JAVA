package com.customer.infrastructure.mapper;

import com.customer.domain.model.*;
import com.customer.infrastructure.adapter.in.rest.dto.*;
import com.customer.infrastructure.persistence.entity.*;
import org.mapstruct.AfterMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;

import java.util.List;

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

    @Mapping(target = "addresses", ignore = true)
    @Mapping(target = "contacts", ignore = true)
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

    CustomerAddress toDomain(CustomerAddressEntity entity);

    CustomerAddressEntity toEntity(CustomerAddress domain);

    CustomerAddress toDomain(CustomerAddressDto dto);

    CustomerAddressDto toDto(CustomerAddress domain);

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

    Customer toDomain(CreateCustomerRequest request);

    Customer toDomain(UpdateCustomerRequest request);

    CustomerResponse toResponse(Customer domain);
}
