package com.allianceever.conversationalhub.infrastructure.persistence.repositories;

import com.allianceever.conversationalhub.infrastructure.persistence.entities.ChannelEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface JpaChannelRepository extends JpaRepository<ChannelEntity, String> {
    List<ChannelEntity> findByTenantId(String tenantId);

    Optional<ChannelEntity> findByErpEntityIdAndErpEntityType(String entityId, String entityType);
}
