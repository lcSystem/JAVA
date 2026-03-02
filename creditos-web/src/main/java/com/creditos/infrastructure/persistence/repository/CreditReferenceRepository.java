package com.creditos.infrastructure.persistence.repository;

import com.creditos.model.CreditReference;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CreditReferenceRepository extends JpaRepository<CreditReference, Long> {
    List<CreditReference> findByOwnerIdAndOwnerType(Long ownerId, String ownerType);
}
