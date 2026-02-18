package com.allianceever.creditos.repository;

import com.allianceever.creditos.model.CreditRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CreditRequestRepository extends JpaRepository<CreditRequest, Long> {
    List<CreditRequest> findByApplicantUserId(Long userId);
}
