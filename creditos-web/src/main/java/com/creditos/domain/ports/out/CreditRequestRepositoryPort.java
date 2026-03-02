package com.creditos.domain.ports.out;

import com.creditos.domain.model.CreditRequest;
import java.util.List;
import java.util.Optional;

public interface CreditRequestRepositoryPort {
    CreditRequest save(CreditRequest creditRequest);

    Optional<CreditRequest> findById(Long id);

    List<CreditRequest> findByApplicantUserId(Long userId);

    List<CreditRequest> findAll();
}
