package com.allianceever.parametrizaciones.domain.ports.out;

import com.allianceever.parametrizaciones.domain.model.events.ParameterUpdatedEvent;

public interface ParameterEventPublisherPort {
    void publish(ParameterUpdatedEvent event);
}
