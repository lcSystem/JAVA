package com.creditos.infrastructure.persistence.repository;

import com.creditos.model.CoDebtorProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CoDebtorProfileRepository extends JpaRepository<CoDebtorProfile, Long> {
    Optional<CoDebtorProfile> findByDocumentId(String documentId);
}
