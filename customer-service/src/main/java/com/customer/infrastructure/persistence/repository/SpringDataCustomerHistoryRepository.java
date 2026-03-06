package com.customer.infrastructure.persistence.repository;

import com.customer.infrastructure.persistence.entity.CustomerHistoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SpringDataCustomerHistoryRepository extends JpaRepository<CustomerHistoryEntity, Long> {
    List<CustomerHistoryEntity> findByCustomerIdOrderByCreatedAtDesc(Long customerId);
}
