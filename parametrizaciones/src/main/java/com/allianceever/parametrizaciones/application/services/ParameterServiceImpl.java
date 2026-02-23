package com.allianceever.parametrizaciones.application.services;

import com.allianceever.parametrizaciones.domain.model.Parameter;
import com.allianceever.parametrizaciones.domain.model.events.ParameterUpdatedEvent;
import com.allianceever.parametrizaciones.domain.ports.in.ParameterServicePort;
import com.allianceever.parametrizaciones.domain.ports.out.ParameterEventPublisherPort;
import com.allianceever.parametrizaciones.domain.ports.out.ParameterRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ParameterServiceImpl implements ParameterServicePort {

    private final ParameterRepositoryPort repository;
    private final ParameterEventPublisherPort eventPublisher;

    @Override
    @Transactional
    public Parameter createParameter(Parameter parameter) {
        parameter.setEnabled(true);
        parameter.setCreatedAt(LocalDateTime.now());
        Parameter saved = repository.save(parameter);
        publishEvent(saved);
        return saved;
    }

    @Override
    @Transactional
    public Parameter updateParameter(Long id, Parameter parameter) {
        return repository.findById(id).map(existing -> {
            existing.setName(parameter.getName());
            existing.setValue(parameter.getValue());
            existing.setType(parameter.getType());
            existing.setEnabled(parameter.isEnabled());
            existing.setUpdatedBy(parameter.getUpdatedBy());
            existing.setUpdatedAt(LocalDateTime.now());

            Parameter saved = repository.save(existing);
            publishEvent(saved);
            return saved;
        }).orElseThrow(() -> new RuntimeException("Parameter not found with id: " + id));
    }

    @Override
    public Optional<Parameter> getParameterById(Long id) {
        return repository.findById(id);
    }

    @Override
    public Optional<Parameter> getParameterByServiceAndKey(String service, String key) {
        return repository.findByServiceAndKey(service, key);
    }

    @Override
    public List<Parameter> getParametersByService(String service) {
        return repository.findByService(service).stream()
                .filter(Parameter::isEnabled)
                .collect(Collectors.toList());
    }

    @Override
    public List<Parameter> getAllParameters() {
        return repository.findAll();
    }

    @Override
    @Transactional
    public void deleteParameter(Long id) {
        repository.findById(id).ifPresent(param -> {
            param.setEnabled(false);
            param.setUpdatedAt(LocalDateTime.now());
            repository.save(param);
            publishEvent(param); // Notify about soft-delete
        });
    }

    @Override
    @Transactional
    public void hardDeleteParameter(Long id) {
        repository.deleteById(id);
    }

    private void publishEvent(Parameter parameter) {
        try {
            ParameterUpdatedEvent event = ParameterUpdatedEvent.builder()
                    .eventId(UUID.randomUUID().toString())
                    .serviceName(parameter.getServiceName())
                    .key(parameter.getKey())
                    .value(parameter.getValue())
                    .version(parameter.getVersion())
                    .timestamp(LocalDateTime.now())
                    .signature("SIG-" + parameter.getKey() + "-" + parameter.getVersion())
                    .build();
            eventPublisher.publish(event);
        } catch (Exception e) {
            // Log the error but don't fail the transaction
            System.err.println("Failed to publish event to RabbitMQ: " + e.getMessage());
        }
    }
}
