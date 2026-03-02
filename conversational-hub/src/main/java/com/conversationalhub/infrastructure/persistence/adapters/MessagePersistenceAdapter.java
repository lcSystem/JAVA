package com.conversationalhub.infrastructure.persistence.adapters;

import com.conversationalhub.domain.entities.Message;
import com.conversationalhub.domain.ports.out.MessageRepositoryPort;
import com.conversationalhub.infrastructure.persistence.entities.MessageEntity;
import com.conversationalhub.infrastructure.persistence.mappers.MessageMapper;
import com.conversationalhub.infrastructure.persistence.repositories.JpaMessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class MessagePersistenceAdapter implements MessageRepositoryPort {
    private final JpaMessageRepository repository;
    private final MessageMapper mapper;

    @Override
    public Message save(Message message) {
        MessageEntity entity = mapper.toEntity(message);
        MessageEntity saved = repository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public List<Message> findByChannelId(String channelId) {
        return repository.findByChannelId(channelId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Message> findForUserSince(String userId, java.time.LocalDateTime since) {
        return repository.findForUserSince(userId, since).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
