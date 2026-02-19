package com.allianceever.creditos.domain.ports.out;

import com.allianceever.creditos.domain.model.CreditType;
import java.util.List;
import java.util.Optional;

public interface CreditTypeRepositoryPort {
    Optional<CreditType> findById(Long id);

    List<CreditType> findAllActive();
}
