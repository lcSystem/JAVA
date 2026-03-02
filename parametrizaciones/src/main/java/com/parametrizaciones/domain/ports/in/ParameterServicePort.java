package com.parametrizaciones.domain.ports.in;

import com.parametrizaciones.domain.model.Parameter;
import java.util.List;
import java.util.Optional;

public interface ParameterServicePort {
    Parameter createParameter(Parameter parameter);

    Parameter updateParameter(Long id, Parameter parameter);

    Optional<Parameter> getParameterById(Long id);

    Optional<Parameter> getParameterByServiceAndKey(String service, String key);

    List<Parameter> getParametersByService(String service);

    List<Parameter> getAllParameters();

    void deleteParameter(Long id);

    void hardDeleteParameter(Long id);
}
