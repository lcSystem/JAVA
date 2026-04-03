package com.customer.infrastructure.mapper;

import com.customer.domain.model.Customer;
import com.customer.domain.model.CustomerAddress;
import com.customer.domain.model.CustomerContact;
import com.customer.domain.model.CustomerHistory;
import com.customer.domain.model.CustomerNote;
import com.customer.infrastructure.adapter.in.rest.dto.CreateCustomerRequest;
import com.customer.infrastructure.adapter.in.rest.dto.CustomerAddressDto;
import com.customer.infrastructure.adapter.in.rest.dto.CustomerContactDto;
import com.customer.infrastructure.adapter.in.rest.dto.CustomerHistoryDto;
import com.customer.infrastructure.adapter.in.rest.dto.CustomerNoteDto;
import com.customer.infrastructure.adapter.in.rest.dto.CustomerResponse;
import com.customer.infrastructure.adapter.in.rest.dto.UpdateCustomerRequest;
import com.customer.infrastructure.persistence.entity.CustomerAddressEntity;
import com.customer.infrastructure.persistence.entity.CustomerContactEntity;
import com.customer.infrastructure.persistence.entity.CustomerEntity;
import com.customer.infrastructure.persistence.entity.CustomerHistoryEntity;
import com.customer.infrastructure.persistence.entity.CustomerNoteEntity;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-03-25T17:07:40-0500",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.45.0.v20260128-0750, environment: Java 21.0.9 (Eclipse Adoptium)"
)
@Component
public class CustomerMapperImpl implements CustomerMapper {

    @Override
    public Customer toDomain(CustomerEntity entity) {
        if ( entity == null ) {
            return null;
        }

        Customer.CustomerBuilder customer = Customer.builder();

        customer.addresses( customerAddressEntityListToCustomerAddressList( entity.getAddresses() ) );
        customer.contacts( customerContactEntityListToCustomerContactList( entity.getContacts() ) );
        customer.createdAt( entity.getCreatedAt() );
        customer.createdBy( entity.getCreatedBy() );
        customer.deletedAt( entity.getDeletedAt() );
        customer.documentNumber( entity.getDocumentNumber() );
        customer.email( entity.getEmail() );
        customer.id( entity.getId() );
        customer.name( entity.getName() );
        customer.phone( entity.getPhone() );
        customer.status( entity.getStatus() );
        customer.type( entity.getType() );
        customer.updatedAt( entity.getUpdatedAt() );
        customer.updatedBy( entity.getUpdatedBy() );

        return customer.build();
    }

    @Override
    public Customer toDomainNoRelationships(CustomerEntity entity) {
        if ( entity == null ) {
            return null;
        }

        Customer.CustomerBuilder customer = Customer.builder();

        customer.createdAt( entity.getCreatedAt() );
        customer.createdBy( entity.getCreatedBy() );
        customer.deletedAt( entity.getDeletedAt() );
        customer.documentNumber( entity.getDocumentNumber() );
        customer.email( entity.getEmail() );
        customer.id( entity.getId() );
        customer.name( entity.getName() );
        customer.phone( entity.getPhone() );
        customer.status( entity.getStatus() );
        customer.type( entity.getType() );
        customer.updatedAt( entity.getUpdatedAt() );
        customer.updatedBy( entity.getUpdatedBy() );

        return customer.build();
    }

    @Override
    public CustomerEntity toEntity(Customer domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerEntity.CustomerEntityBuilder customerEntity = CustomerEntity.builder();

        customerEntity.addresses( customerAddressListToCustomerAddressEntityList( domain.getAddresses() ) );
        customerEntity.contacts( customerContactListToCustomerContactEntityList( domain.getContacts() ) );
        customerEntity.createdAt( domain.getCreatedAt() );
        customerEntity.createdBy( domain.getCreatedBy() );
        customerEntity.deletedAt( domain.getDeletedAt() );
        customerEntity.documentNumber( domain.getDocumentNumber() );
        customerEntity.email( domain.getEmail() );
        customerEntity.id( domain.getId() );
        customerEntity.name( domain.getName() );
        customerEntity.phone( domain.getPhone() );
        customerEntity.status( domain.getStatus() );
        customerEntity.type( domain.getType() );
        customerEntity.updatedAt( domain.getUpdatedAt() );
        customerEntity.updatedBy( domain.getUpdatedBy() );

        return customerEntity.build();
    }

    @Override
    public CustomerAddress toDomain(CustomerAddressEntity entity) {
        if ( entity == null ) {
            return null;
        }

        CustomerAddress.CustomerAddressBuilder customerAddress = CustomerAddress.builder();

        customerAddress.customerId( entityCustomerId( entity ) );
        customerAddress.addressType( entity.getAddressType() );
        customerAddress.city( entity.getCity() );
        customerAddress.country( entity.getCountry() );
        customerAddress.createdAt( entity.getCreatedAt() );
        customerAddress.id( entity.getId() );
        customerAddress.postalCode( entity.getPostalCode() );
        customerAddress.state( entity.getState() );
        customerAddress.street( entity.getStreet() );

        return customerAddress.build();
    }

    @Override
    public CustomerAddressEntity toEntity(CustomerAddress domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerAddressEntity.CustomerAddressEntityBuilder customerAddressEntity = CustomerAddressEntity.builder();

        customerAddressEntity.addressType( domain.getAddressType() );
        customerAddressEntity.city( domain.getCity() );
        customerAddressEntity.country( domain.getCountry() );
        customerAddressEntity.createdAt( domain.getCreatedAt() );
        customerAddressEntity.id( domain.getId() );
        customerAddressEntity.postalCode( domain.getPostalCode() );
        customerAddressEntity.state( domain.getState() );
        customerAddressEntity.street( domain.getStreet() );

        return customerAddressEntity.build();
    }

    @Override
    public CustomerAddress toDomain(CustomerAddressDto dto) {
        if ( dto == null ) {
            return null;
        }

        CustomerAddress.CustomerAddressBuilder customerAddress = CustomerAddress.builder();

        customerAddress.addressType( dto.getType() );
        customerAddress.city( dto.getCity() );
        customerAddress.country( dto.getCountry() );
        customerAddress.id( dto.getId() );
        customerAddress.postalCode( dto.getPostalCode() );
        customerAddress.state( dto.getState() );
        customerAddress.street( dto.getStreet() );

        return customerAddress.build();
    }

    @Override
    public CustomerAddressDto toDto(CustomerAddress domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerAddressDto customerAddressDto = new CustomerAddressDto();

        customerAddressDto.setType( domain.getAddressType() );
        customerAddressDto.setCity( domain.getCity() );
        customerAddressDto.setCountry( domain.getCountry() );
        customerAddressDto.setId( domain.getId() );
        customerAddressDto.setPostalCode( domain.getPostalCode() );
        customerAddressDto.setState( domain.getState() );
        customerAddressDto.setStreet( domain.getStreet() );

        return customerAddressDto;
    }

    @Override
    public CustomerContact toDomain(CustomerContactEntity entity) {
        if ( entity == null ) {
            return null;
        }

        CustomerContact.CustomerContactBuilder customerContact = CustomerContact.builder();

        customerContact.customerId( entityCustomerId1( entity ) );
        customerContact.birthDate( entity.getBirthDate() );
        customerContact.createdAt( entity.getCreatedAt() );
        customerContact.documentNumber( entity.getDocumentNumber() );
        customerContact.email( entity.getEmail() );
        customerContact.id( entity.getId() );
        customerContact.isLegalRepresentative( entity.getIsLegalRepresentative() );
        customerContact.name( entity.getName() );
        customerContact.phone( entity.getPhone() );
        customerContact.position( entity.getPosition() );

        return customerContact.build();
    }

    @Override
    public CustomerContactEntity toEntity(CustomerContact domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerContactEntity.CustomerContactEntityBuilder customerContactEntity = CustomerContactEntity.builder();

        customerContactEntity.birthDate( domain.getBirthDate() );
        customerContactEntity.createdAt( domain.getCreatedAt() );
        customerContactEntity.documentNumber( domain.getDocumentNumber() );
        customerContactEntity.email( domain.getEmail() );
        customerContactEntity.id( domain.getId() );
        customerContactEntity.isLegalRepresentative( domain.getIsLegalRepresentative() );
        customerContactEntity.name( domain.getName() );
        customerContactEntity.phone( domain.getPhone() );
        customerContactEntity.position( domain.getPosition() );

        return customerContactEntity.build();
    }

    @Override
    public CustomerContact toDomain(CustomerContactDto dto) {
        if ( dto == null ) {
            return null;
        }

        CustomerContact.CustomerContactBuilder customerContact = CustomerContact.builder();

        customerContact.birthDate( dto.getBirthDate() );
        customerContact.createdAt( dto.getCreatedAt() );
        customerContact.documentNumber( dto.getDocumentNumber() );
        customerContact.email( dto.getEmail() );
        customerContact.id( dto.getId() );
        customerContact.isLegalRepresentative( dto.getIsLegalRepresentative() );
        customerContact.name( dto.getName() );
        customerContact.phone( dto.getPhone() );
        customerContact.position( dto.getPosition() );

        return customerContact.build();
    }

    @Override
    public CustomerContactDto toDto(CustomerContact domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerContactDto customerContactDto = new CustomerContactDto();

        customerContactDto.setBirthDate( domain.getBirthDate() );
        customerContactDto.setCreatedAt( domain.getCreatedAt() );
        customerContactDto.setDocumentNumber( domain.getDocumentNumber() );
        customerContactDto.setEmail( domain.getEmail() );
        customerContactDto.setId( domain.getId() );
        customerContactDto.setIsLegalRepresentative( domain.getIsLegalRepresentative() );
        customerContactDto.setName( domain.getName() );
        customerContactDto.setPhone( domain.getPhone() );
        customerContactDto.setPosition( domain.getPosition() );

        return customerContactDto;
    }

    @Override
    public CustomerNote toDomain(CustomerNoteEntity entity) {
        if ( entity == null ) {
            return null;
        }

        CustomerNote.CustomerNoteBuilder customerNote = CustomerNote.builder();

        customerNote.createdAt( entity.getCreatedAt() );
        customerNote.createdBy( entity.getCreatedBy() );
        customerNote.id( entity.getId() );
        customerNote.note( entity.getNote() );

        return customerNote.build();
    }

    @Override
    public CustomerNoteEntity toEntity(CustomerNote domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerNoteEntity.CustomerNoteEntityBuilder customerNoteEntity = CustomerNoteEntity.builder();

        customerNoteEntity.createdAt( domain.getCreatedAt() );
        customerNoteEntity.createdBy( domain.getCreatedBy() );
        customerNoteEntity.id( domain.getId() );
        customerNoteEntity.note( domain.getNote() );

        return customerNoteEntity.build();
    }

    @Override
    public CustomerNote toDomain(CustomerNoteDto dto) {
        if ( dto == null ) {
            return null;
        }

        CustomerNote.CustomerNoteBuilder customerNote = CustomerNote.builder();

        customerNote.createdAt( dto.getCreatedAt() );
        customerNote.createdBy( dto.getCreatedBy() );
        customerNote.id( dto.getId() );
        customerNote.note( dto.getNote() );

        return customerNote.build();
    }

    @Override
    public CustomerNoteDto toDto(CustomerNote domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerNoteDto customerNoteDto = new CustomerNoteDto();

        customerNoteDto.setCreatedAt( domain.getCreatedAt() );
        customerNoteDto.setCreatedBy( domain.getCreatedBy() );
        customerNoteDto.setId( domain.getId() );
        customerNoteDto.setNote( domain.getNote() );

        return customerNoteDto;
    }

    @Override
    public CustomerHistory toDomain(CustomerHistoryEntity entity) {
        if ( entity == null ) {
            return null;
        }

        CustomerHistory.CustomerHistoryBuilder customerHistory = CustomerHistory.builder();

        customerHistory.createdAt( entity.getCreatedAt() );
        customerHistory.createdBy( entity.getCreatedBy() );
        customerHistory.description( entity.getDescription() );
        customerHistory.eventType( entity.getEventType() );
        customerHistory.id( entity.getId() );

        return customerHistory.build();
    }

    @Override
    public CustomerHistoryEntity toEntity(CustomerHistory domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerHistoryEntity.CustomerHistoryEntityBuilder customerHistoryEntity = CustomerHistoryEntity.builder();

        customerHistoryEntity.createdAt( domain.getCreatedAt() );
        customerHistoryEntity.createdBy( domain.getCreatedBy() );
        customerHistoryEntity.description( domain.getDescription() );
        customerHistoryEntity.eventType( domain.getEventType() );
        customerHistoryEntity.id( domain.getId() );

        return customerHistoryEntity.build();
    }

    @Override
    public CustomerHistory toDomain(CustomerHistoryDto dto) {
        if ( dto == null ) {
            return null;
        }

        CustomerHistory.CustomerHistoryBuilder customerHistory = CustomerHistory.builder();

        customerHistory.createdAt( dto.getCreatedAt() );
        customerHistory.createdBy( dto.getCreatedBy() );
        customerHistory.description( dto.getDescription() );
        customerHistory.eventType( dto.getEventType() );
        customerHistory.id( dto.getId() );

        return customerHistory.build();
    }

    @Override
    public CustomerHistoryDto toDto(CustomerHistory domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerHistoryDto customerHistoryDto = new CustomerHistoryDto();

        customerHistoryDto.setCreatedAt( domain.getCreatedAt() );
        customerHistoryDto.setCreatedBy( domain.getCreatedBy() );
        customerHistoryDto.setDescription( domain.getDescription() );
        customerHistoryDto.setEventType( domain.getEventType() );
        customerHistoryDto.setId( domain.getId() );

        return customerHistoryDto;
    }

    @Override
    public Customer toDomain(CreateCustomerRequest request) {
        if ( request == null ) {
            return null;
        }

        Customer.CustomerBuilder customer = Customer.builder();

        customer.addresses( customerAddressDtoListToCustomerAddressList( request.getAddresses() ) );
        customer.contacts( customerContactDtoListToCustomerContactList( request.getContacts() ) );
        customer.documentNumber( request.getDocumentNumber() );
        customer.email( request.getEmail() );
        customer.name( request.getName() );
        customer.phone( request.getPhone() );
        customer.type( request.getType() );

        return customer.build();
    }

    @Override
    public Customer toDomain(UpdateCustomerRequest request) {
        if ( request == null ) {
            return null;
        }

        Customer.CustomerBuilder customer = Customer.builder();

        customer.addresses( customerAddressDtoListToCustomerAddressList( request.getAddresses() ) );
        customer.contacts( customerContactDtoListToCustomerContactList( request.getContacts() ) );
        customer.documentNumber( request.getDocumentNumber() );
        customer.email( request.getEmail() );
        customer.id( request.getId() );
        customer.name( request.getName() );
        customer.phone( request.getPhone() );
        customer.status( request.getStatus() );
        customer.type( request.getType() );

        return customer.build();
    }

    @Override
    public CustomerResponse toResponse(Customer domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerResponse customerResponse = new CustomerResponse();

        customerResponse.setAddresses( customerAddressListToCustomerAddressDtoList( domain.getAddresses() ) );
        customerResponse.setContacts( customerContactListToCustomerContactDtoList( domain.getContacts() ) );
        customerResponse.setCreatedAt( domain.getCreatedAt() );
        customerResponse.setCreatedBy( domain.getCreatedBy() );
        customerResponse.setDocumentNumber( domain.getDocumentNumber() );
        customerResponse.setEmail( domain.getEmail() );
        customerResponse.setHistory( customerHistoryListToCustomerHistoryDtoList( domain.getHistory() ) );
        customerResponse.setId( domain.getId() );
        customerResponse.setName( domain.getName() );
        customerResponse.setNotes( customerNoteListToCustomerNoteDtoList( domain.getNotes() ) );
        customerResponse.setPhone( domain.getPhone() );
        customerResponse.setStatus( domain.getStatus() );
        customerResponse.setType( domain.getType() );
        customerResponse.setUpdatedAt( domain.getUpdatedAt() );
        customerResponse.setUpdatedBy( domain.getUpdatedBy() );

        return customerResponse;
    }

    protected List<CustomerAddress> customerAddressEntityListToCustomerAddressList(List<CustomerAddressEntity> list) {
        if ( list == null ) {
            return null;
        }

        List<CustomerAddress> list1 = new ArrayList<CustomerAddress>( list.size() );
        for ( CustomerAddressEntity customerAddressEntity : list ) {
            list1.add( toDomain( customerAddressEntity ) );
        }

        return list1;
    }

    protected List<CustomerContact> customerContactEntityListToCustomerContactList(List<CustomerContactEntity> list) {
        if ( list == null ) {
            return null;
        }

        List<CustomerContact> list1 = new ArrayList<CustomerContact>( list.size() );
        for ( CustomerContactEntity customerContactEntity : list ) {
            list1.add( toDomain( customerContactEntity ) );
        }

        return list1;
    }

    protected List<CustomerAddressEntity> customerAddressListToCustomerAddressEntityList(List<CustomerAddress> list) {
        if ( list == null ) {
            return null;
        }

        List<CustomerAddressEntity> list1 = new ArrayList<CustomerAddressEntity>( list.size() );
        for ( CustomerAddress customerAddress : list ) {
            list1.add( toEntity( customerAddress ) );
        }

        return list1;
    }

    protected List<CustomerContactEntity> customerContactListToCustomerContactEntityList(List<CustomerContact> list) {
        if ( list == null ) {
            return null;
        }

        List<CustomerContactEntity> list1 = new ArrayList<CustomerContactEntity>( list.size() );
        for ( CustomerContact customerContact : list ) {
            list1.add( toEntity( customerContact ) );
        }

        return list1;
    }

    private Long entityCustomerId(CustomerAddressEntity customerAddressEntity) {
        if ( customerAddressEntity == null ) {
            return null;
        }
        CustomerEntity customer = customerAddressEntity.getCustomer();
        if ( customer == null ) {
            return null;
        }
        Long id = customer.getId();
        if ( id == null ) {
            return null;
        }
        return id;
    }

    private Long entityCustomerId1(CustomerContactEntity customerContactEntity) {
        if ( customerContactEntity == null ) {
            return null;
        }
        CustomerEntity customer = customerContactEntity.getCustomer();
        if ( customer == null ) {
            return null;
        }
        Long id = customer.getId();
        if ( id == null ) {
            return null;
        }
        return id;
    }

    protected List<CustomerAddress> customerAddressDtoListToCustomerAddressList(List<CustomerAddressDto> list) {
        if ( list == null ) {
            return null;
        }

        List<CustomerAddress> list1 = new ArrayList<CustomerAddress>( list.size() );
        for ( CustomerAddressDto customerAddressDto : list ) {
            list1.add( toDomain( customerAddressDto ) );
        }

        return list1;
    }

    protected List<CustomerContact> customerContactDtoListToCustomerContactList(List<CustomerContactDto> list) {
        if ( list == null ) {
            return null;
        }

        List<CustomerContact> list1 = new ArrayList<CustomerContact>( list.size() );
        for ( CustomerContactDto customerContactDto : list ) {
            list1.add( toDomain( customerContactDto ) );
        }

        return list1;
    }

    protected List<CustomerAddressDto> customerAddressListToCustomerAddressDtoList(List<CustomerAddress> list) {
        if ( list == null ) {
            return null;
        }

        List<CustomerAddressDto> list1 = new ArrayList<CustomerAddressDto>( list.size() );
        for ( CustomerAddress customerAddress : list ) {
            list1.add( toDto( customerAddress ) );
        }

        return list1;
    }

    protected List<CustomerContactDto> customerContactListToCustomerContactDtoList(List<CustomerContact> list) {
        if ( list == null ) {
            return null;
        }

        List<CustomerContactDto> list1 = new ArrayList<CustomerContactDto>( list.size() );
        for ( CustomerContact customerContact : list ) {
            list1.add( toDto( customerContact ) );
        }

        return list1;
    }

    protected List<CustomerHistoryDto> customerHistoryListToCustomerHistoryDtoList(List<CustomerHistory> list) {
        if ( list == null ) {
            return null;
        }

        List<CustomerHistoryDto> list1 = new ArrayList<CustomerHistoryDto>( list.size() );
        for ( CustomerHistory customerHistory : list ) {
            list1.add( toDto( customerHistory ) );
        }

        return list1;
    }

    protected List<CustomerNoteDto> customerNoteListToCustomerNoteDtoList(List<CustomerNote> list) {
        if ( list == null ) {
            return null;
        }

        List<CustomerNoteDto> list1 = new ArrayList<CustomerNoteDto>( list.size() );
        for ( CustomerNote customerNote : list ) {
            list1.add( toDto( customerNote ) );
        }

        return list1;
    }
}
