package com.conversationalhub.infrastructure.persistence.adapters;

import com.conversationalhub.domain.entities.Channel;
import com.conversationalhub.domain.ports.out.ChannelRepositoryPort;
import com.conversationalhub.infrastructure.persistence.entities.ChannelEntity;
import com.conversationalhub.infrastructure.persistence.mappers.ChannelMapper;
import com.conversationalhub.infrastructure.persistence.repositories.JpaChannelRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class ChannelPersistenceAdapter implements ChannelRepositoryPort {
    private final JpaChannelRepository repository;
    private final ChannelMapper mapper;

    @Override
    public Channel save(Channel channel) {
        ChannelEntity entity = mapper.toEntity(channel);
        ChannelEntity saved = repository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<Channel> findById(String id) {
        return repository.findById(id).map(mapper::toDomain);
    }

    @Override
    public List<Channel> findByTenantId(String tenantId) {
        return repository.findByTenantId(tenantId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<Channel> findByErpEntity(String entityId, String entityType) {
        return repository.findByErpEntityIdAndErpEntityType(entityId, entityType)
                .map(mapper::toDomain);
    }
}
