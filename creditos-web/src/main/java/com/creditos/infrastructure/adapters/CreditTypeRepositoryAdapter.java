package com.creditos.infrastructure.adapters;

import com.creditos.domain.model.CreditType;
import com.creditos.domain.ports.out.CreditTypeRepositoryPort;
import com.creditos.infrastructure.mappers.CreditTypeMapper;
import com.creditos.repository.CreditTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class CreditTypeRepositoryAdapter implements CreditTypeRepositoryPort {

    private final CreditTypeRepository creditTypeRepository;

    @Override
    public Optional<CreditType> findById(Long id) {
        return creditTypeRepository.findById(id).map(CreditTypeMapper::toDomain);
    }

    @Override
    public List<CreditType> findAllActive() {
        return creditTypeRepository.findAll().stream()
                .filter(com.creditos.model.CreditType::getActive)
                .map(CreditTypeMapper::toDomain)
                .collect(Collectors.toList());
    }
}
