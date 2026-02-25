package com.allianceever.conversationalhub.domain.ports.out;

import com.allianceever.conversationalhub.domain.entities.Channel;
import java.util.List;
import java.util.Optional;

public interface ChannelRepositoryPort {
    Channel save(Channel channel);

    Optional<Channel> findById(String id);

    List<Channel> findByTenantId(String tenantId);

    Optional<Channel> findByErpEntity(String entityId, String entityType);
}
