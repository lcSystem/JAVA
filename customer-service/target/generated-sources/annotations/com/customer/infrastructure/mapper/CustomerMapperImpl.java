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
    date = "2026-03-07T20:00:01-0400",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 21.0.10 (Ubuntu)"
)
@Component
public class CustomerMapperImpl implements CustomerMapper {

    @Override
    public Customer toDomain(CustomerEntity entity) {
        if ( entity == null ) {
            return null;
        }

        Customer.CustomerBuilder customer = Customer.builder();

        customer.id( entity.getId() );
        customer.type( entity.getType() );
        customer.name( entity.getName() );
        customer.documentNumber( entity.getDocumentNumber() );
        customer.email( entity.getEmail() );
        customer.phone( entity.getPhone() );
        customer.status( entity.getStatus() );
        customer.createdAt( entity.getCreatedAt() );
        customer.updatedAt( entity.getUpdatedAt() );
        customer.createdBy( entity.getCreatedBy() );
        customer.updatedBy( entity.getUpdatedBy() );
        customer.deletedAt( entity.getDeletedAt() );
        customer.addresses( customerAddressEntityListToCustomerAddressList( entity.getAddresses() ) );
        customer.contacts( customerContactEntityListToCustomerContactList( entity.getContacts() ) );

        return customer.build();
    }

    @Override
    public Customer toDomainNoRelationships(CustomerEntity entity) {
        if ( entity == null ) {
            return null;
        }

        Customer.CustomerBuilder customer = Customer.builder();

        customer.id( entity.getId() );
        customer.type( entity.getType() );
        customer.name( entity.getName() );
        customer.documentNumber( entity.getDocumentNumber() );
        customer.email( entity.getEmail() );
        customer.phone( entity.getPhone() );
        customer.status( entity.getStatus() );
        customer.createdAt( entity.getCreatedAt() );
        customer.updatedAt( entity.getUpdatedAt() );
        customer.createdBy( entity.getCreatedBy() );
        customer.updatedBy( entity.getUpdatedBy() );
        customer.deletedAt( entity.getDeletedAt() );

        return customer.build();
    }

    @Override
    public CustomerEntity toEntity(Customer domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerEntity.CustomerEntityBuilder customerEntity = CustomerEntity.builder();

        customerEntity.id( domain.getId() );
        customerEntity.type( domain.getType() );
        customerEntity.name( domain.getName() );
        customerEntity.documentNumber( domain.getDocumentNumber() );
        customerEntity.email( domain.getEmail() );
        customerEntity.phone( domain.getPhone() );
        customerEntity.status( domain.getStatus() );
        customerEntity.createdAt( domain.getCreatedAt() );
        customerEntity.updatedAt( domain.getUpdatedAt() );
        customerEntity.createdBy( domain.getCreatedBy() );
        customerEntity.updatedBy( domain.getUpdatedBy() );
        customerEntity.deletedAt( domain.getDeletedAt() );
        customerEntity.addresses( customerAddressListToCustomerAddressEntityList( domain.getAddresses() ) );
        customerEntity.contacts( customerContactListToCustomerContactEntityList( domain.getContacts() ) );

        return customerEntity.build();
    }

    @Override
    public CustomerAddress toDomain(CustomerAddressEntity entity) {
        if ( entity == null ) {
            return null;
        }

        CustomerAddress.CustomerAddressBuilder customerAddress = CustomerAddress.builder();

        customerAddress.customerId( entityCustomerId( entity ) );
        customerAddress.id( entity.getId() );
        customerAddress.street( entity.getStreet() );
        customerAddress.city( entity.getCity() );
        customerAddress.state( entity.getState() );
        customerAddress.country( entity.getCountry() );
        customerAddress.postalCode( entity.getPostalCode() );
        customerAddress.addressType( entity.getAddressType() );
        customerAddress.createdAt( entity.getCreatedAt() );

        return customerAddress.build();
    }

    @Override
    public CustomerAddressEntity toEntity(CustomerAddress domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerAddressEntity.CustomerAddressEntityBuilder customerAddressEntity = CustomerAddressEntity.builder();

        customerAddressEntity.id( domain.getId() );
        customerAddressEntity.street( domain.getStreet() );
        customerAddressEntity.city( domain.getCity() );
        customerAddressEntity.state( domain.getState() );
        customerAddressEntity.country( domain.getCountry() );
        customerAddressEntity.postalCode( domain.getPostalCode() );
        customerAddressEntity.addressType( domain.getAddressType() );
        customerAddressEntity.createdAt( domain.getCreatedAt() );

        return customerAddressEntity.build();
    }

    @Override
    public CustomerAddress toDomain(CustomerAddressDto dto) {
        if ( dto == null ) {
            return null;
        }

        CustomerAddress.CustomerAddressBuilder customerAddress = CustomerAddress.builder();

        customerAddress.addressType( dto.getType() );
        customerAddress.id( dto.getId() );
        customerAddress.street( dto.getStreet() );
        customerAddress.city( dto.getCity() );
        customerAddress.state( dto.getState() );
        customerAddress.country( dto.getCountry() );
        customerAddress.postalCode( dto.getPostalCode() );

        return customerAddress.build();
    }

    @Override
    public CustomerAddressDto toDto(CustomerAddress domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerAddressDto customerAddressDto = new CustomerAddressDto();

        customerAddressDto.setType( domain.getAddressType() );
        customerAddressDto.setId( domain.getId() );
        customerAddressDto.setStreet( domain.getStreet() );
        customerAddressDto.setCity( domain.getCity() );
        customerAddressDto.setState( domain.getState() );
        customerAddressDto.setCountry( domain.getCountry() );
        customerAddressDto.setPostalCode( domain.getPostalCode() );

        return customerAddressDto;
    }

    @Override
    public CustomerContact toDomain(CustomerContactEntity entity) {
        if ( entity == null ) {
            return null;
        }

        CustomerContact.CustomerContactBuilder customerContact = CustomerContact.builder();

        customerContact.customerId( entityCustomerId1( entity ) );
        customerContact.id( entity.getId() );
        customerContact.name( entity.getName() );
        customerContact.position( entity.getPosition() );
        customerContact.email( entity.getEmail() );
        customerContact.phone( entity.getPhone() );
        customerContact.documentNumber( entity.getDocumentNumber() );
        customerContact.birthDate( entity.getBirthDate() );
        customerContact.isLegalRepresentative( entity.getIsLegalRepresentative() );
        customerContact.createdAt( entity.getCreatedAt() );

        return customerContact.build();
    }

    @Override
    public CustomerContactEntity toEntity(CustomerContact domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerContactEntity.CustomerContactEntityBuilder customerContactEntity = CustomerContactEntity.builder();

        customerContactEntity.id( domain.getId() );
        customerContactEntity.name( domain.getName() );
        customerContactEntity.position( domain.getPosition() );
        customerContactEntity.email( domain.getEmail() );
        customerContactEntity.phone( domain.getPhone() );
        customerContactEntity.documentNumber( domain.getDocumentNumber() );
        customerContactEntity.birthDate( domain.getBirthDate() );
        customerContactEntity.isLegalRepresentative( domain.getIsLegalRepresentative() );
        customerContactEntity.createdAt( domain.getCreatedAt() );

        return customerContactEntity.build();
    }

    @Override
    public CustomerContact toDomain(CustomerContactDto dto) {
        if ( dto == null ) {
            return null;
        }

        CustomerContact.CustomerContactBuilder customerContact = CustomerContact.builder();

        customerContact.id( dto.getId() );
        customerContact.name( dto.getName() );
        customerContact.position( dto.getPosition() );
        customerContact.email( dto.getEmail() );
        customerContact.phone( dto.getPhone() );
        customerContact.documentNumber( dto.getDocumentNumber() );
        customerContact.birthDate( dto.getBirthDate() );
        customerContact.isLegalRepresentative( dto.getIsLegalRepresentative() );
        customerContact.createdAt( dto.getCreatedAt() );

        return customerContact.build();
    }

    @Override
    public CustomerContactDto toDto(CustomerContact domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerContactDto customerContactDto = new CustomerContactDto();

        customerContactDto.setId( domain.getId() );
        customerContactDto.setName( domain.getName() );
        customerContactDto.setPosition( domain.getPosition() );
        customerContactDto.setEmail( domain.getEmail() );
        customerContactDto.setPhone( domain.getPhone() );
        customerContactDto.setDocumentNumber( domain.getDocumentNumber() );
        customerContactDto.setBirthDate( domain.getBirthDate() );
        customerContactDto.setIsLegalRepresentative( domain.getIsLegalRepresentative() );
        customerContactDto.setCreatedAt( domain.getCreatedAt() );

        return customerContactDto;
    }

    @Override
    public CustomerNote toDomain(CustomerNoteEntity entity) {
        if ( entity == null ) {
            return null;
        }

        CustomerNote.CustomerNoteBuilder customerNote = CustomerNote.builder();

        customerNote.id( entity.getId() );
        customerNote.note( entity.getNote() );
        customerNote.createdBy( entity.getCreatedBy() );
        customerNote.createdAt( entity.getCreatedAt() );

        return customerNote.build();
    }

    @Override
    public CustomerNoteEntity toEntity(CustomerNote domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerNoteEntity.CustomerNoteEntityBuilder customerNoteEntity = CustomerNoteEntity.builder();

        customerNoteEntity.id( domain.getId() );
        customerNoteEntity.note( domain.getNote() );
        customerNoteEntity.createdBy( domain.getCreatedBy() );
        customerNoteEntity.createdAt( domain.getCreatedAt() );

        return customerNoteEntity.build();
    }

    @Override
    public CustomerNote toDomain(CustomerNoteDto dto) {
        if ( dto == null ) {
            return null;
        }

        CustomerNote.CustomerNoteBuilder customerNote = CustomerNote.builder();

        customerNote.id( dto.getId() );
        customerNote.note( dto.getNote() );
        customerNote.createdBy( dto.getCreatedBy() );
        customerNote.createdAt( dto.getCreatedAt() );

        return customerNote.build();
    }

    @Override
    public CustomerNoteDto toDto(CustomerNote domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerNoteDto customerNoteDto = new CustomerNoteDto();

        customerNoteDto.setId( domain.getId() );
        customerNoteDto.setNote( domain.getNote() );
        customerNoteDto.setCreatedBy( domain.getCreatedBy() );
        customerNoteDto.setCreatedAt( domain.getCreatedAt() );

        return customerNoteDto;
    }

    @Override
    public CustomerHistory toDomain(CustomerHistoryEntity entity) {
        if ( entity == null ) {
            return null;
        }

        CustomerHistory.CustomerHistoryBuilder customerHistory = CustomerHistory.builder();

        customerHistory.id( entity.getId() );
        customerHistory.eventType( entity.getEventType() );
        customerHistory.description( entity.getDescription() );
        customerHistory.createdBy( entity.getCreatedBy() );
        customerHistory.createdAt( entity.getCreatedAt() );

        return customerHistory.build();
    }

    @Override
    public CustomerHistoryEntity toEntity(CustomerHistory domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerHistoryEntity.CustomerHistoryEntityBuilder customerHistoryEntity = CustomerHistoryEntity.builder();

        customerHistoryEntity.id( domain.getId() );
        customerHistoryEntity.eventType( domain.getEventType() );
        customerHistoryEntity.description( domain.getDescription() );
        customerHistoryEntity.createdBy( domain.getCreatedBy() );
        customerHistoryEntity.createdAt( domain.getCreatedAt() );

        return customerHistoryEntity.build();
    }

    @Override
    public CustomerHistory toDomain(CustomerHistoryDto dto) {
        if ( dto == null ) {
            return null;
        }

        CustomerHistory.CustomerHistoryBuilder customerHistory = CustomerHistory.builder();

        customerHistory.id( dto.getId() );
        customerHistory.eventType( dto.getEventType() );
        customerHistory.description( dto.getDescription() );
        customerHistory.createdBy( dto.getCreatedBy() );
        customerHistory.createdAt( dto.getCreatedAt() );

        return customerHistory.build();
    }

    @Override
    public CustomerHistoryDto toDto(CustomerHistory domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerHistoryDto customerHistoryDto = new CustomerHistoryDto();

        customerHistoryDto.setId( domain.getId() );
        customerHistoryDto.setEventType( domain.getEventType() );
        customerHistoryDto.setDescription( domain.getDescription() );
        customerHistoryDto.setCreatedBy( domain.getCreatedBy() );
        customerHistoryDto.setCreatedAt( domain.getCreatedAt() );

        return customerHistoryDto;
    }

    @Override
    public Customer toDomain(CreateCustomerRequest request) {
        if ( request == null ) {
            return null;
        }

        Customer.CustomerBuilder customer = Customer.builder();

        customer.type( request.getType() );
        customer.name( request.getName() );
        customer.documentNumber( request.getDocumentNumber() );
        customer.email( request.getEmail() );
        customer.phone( request.getPhone() );
        customer.addresses( customerAddressDtoListToCustomerAddressList( request.getAddresses() ) );
        customer.contacts( customerContactDtoListToCustomerContactList( request.getContacts() ) );

        return customer.build();
    }

    @Override
    public Customer toDomain(UpdateCustomerRequest request) {
        if ( request == null ) {
            return null;
        }

        Customer.CustomerBuilder customer = Customer.builder();

        customer.id( request.getId() );
        customer.type( request.getType() );
        customer.name( request.getName() );
        customer.documentNumber( request.getDocumentNumber() );
        customer.email( request.getEmail() );
        customer.phone( request.getPhone() );
        customer.status( request.getStatus() );
        customer.addresses( customerAddressDtoListToCustomerAddressList( request.getAddresses() ) );
        customer.contacts( customerContactDtoListToCustomerContactList( request.getContacts() ) );

        return customer.build();
    }

    @Override
    public CustomerResponse toResponse(Customer domain) {
        if ( domain == null ) {
            return null;
        }

        CustomerResponse customerResponse = new CustomerResponse();

        customerResponse.setId( domain.getId() );
        customerResponse.setType( domain.getType() );
        customerResponse.setName( domain.getName() );
        customerResponse.setDocumentNumber( domain.getDocumentNumber() );
        customerResponse.setEmail( domain.getEmail() );
        customerResponse.setPhone( domain.getPhone() );
        customerResponse.setStatus( domain.getStatus() );
        customerResponse.setCreatedAt( domain.getCreatedAt() );
        customerResponse.setUpdatedAt( domain.getUpdatedAt() );
        customerResponse.setCreatedBy( domain.getCreatedBy() );
        customerResponse.setUpdatedBy( domain.getUpdatedBy() );
        customerResponse.setAddresses( customerAddressListToCustomerAddressDtoList( domain.getAddresses() ) );
        customerResponse.setContacts( customerContactListToCustomerContactDtoList( domain.getContacts() ) );
        customerResponse.setNotes( customerNoteListToCustomerNoteDtoList( domain.getNotes() ) );
        customerResponse.setHistory( customerHistoryListToCustomerHistoryDtoList( domain.getHistory() ) );

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
}
