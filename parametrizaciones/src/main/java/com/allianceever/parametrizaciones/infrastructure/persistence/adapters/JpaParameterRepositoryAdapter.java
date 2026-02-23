package com.allianceever.parametrizaciones.infrastructure.persistence.adapters;

import com.allianceever.parametrizaciones.domain.model.Parameter;
import com.allianceever.parametrizaciones.domain.ports.out.ParameterRepositoryPort;
import com.allianceever.parametrizaciones.infrastructure.persistence.entities.ParameterJpaEntity;
import com.allianceever.parametrizaciones.infrastructure.persistence.mappers.ParameterMapper;
import com.allianceever.parametrizaciones.infrastructure.persistence.repositories.SpringDataParameterRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaParameterRepositoryAdapter implements ParameterRepositoryPort {

    private final SpringDataParameterRepository repository;
    private final ParameterMapper mapper;

    @Override
    public Parameter save(Parameter parameter) {
        ParameterJpaEntity entity = mapper.toJpaEntity(parameter);
        ParameterJpaEntity saved = repository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<Parameter> findById(Long id) {
        return repository.findById(id).map(mapper::toDomain);
    }

    @Override
    public Optional<Parameter> findByServiceAndKey(String service, String key) {
        return repository.findByServiceNameAndKey(service, key).map(mapper::toDomain);
    }

    @Override
    public List<Parameter> findByService(String service) {
        return repository.findByServiceNameAndEnabledTrue(service).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Parameter> findAll() {
        return repository.findAll().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
