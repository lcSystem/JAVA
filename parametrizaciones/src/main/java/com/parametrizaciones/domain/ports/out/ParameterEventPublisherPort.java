package com.parametrizaciones.domain.ports.out;

import com.parametrizaciones.domain.model.events.ParameterUpdatedEvent;

public interface ParameterEventPublisherPort {
    void publish(ParameterUpdatedEvent event);
}
