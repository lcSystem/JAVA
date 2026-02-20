package com.allianceever.parametrizaciones.domain.ports.out;

import com.allianceever.parametrizaciones.domain.model.Parameter;
import java.util.List;
import java.util.Optional;

public interface ParameterRepositoryPort {
    Parameter save(Parameter parameter);

    Optional<Parameter> findById(Long id);

    Optional<Parameter> findByServiceAndKey(String service, String key);

    List<Parameter> findByService(String service);

    List<Parameter> findAll();

    void deleteById(Long id);
}
