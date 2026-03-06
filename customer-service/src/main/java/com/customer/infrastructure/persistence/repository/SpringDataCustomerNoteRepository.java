package com.customer.infrastructure.persistence.repository;

import com.customer.infrastructure.persistence.entity.CustomerNoteEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SpringDataCustomerNoteRepository extends JpaRepository<CustomerNoteEntity, Long> {
    List<CustomerNoteEntity> findByCustomerIdOrderByCreatedAtDesc(Long customerId);
}
