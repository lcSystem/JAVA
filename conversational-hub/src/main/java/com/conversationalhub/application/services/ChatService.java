package com.conversationalhub.application.services;

import com.conversationalhub.domain.entities.Channel;
import com.conversationalhub.domain.entities.Message;
import com.conversationalhub.domain.ports.in.ChatUseCase;
import com.conversationalhub.domain.ports.out.ChannelRepositoryPort;
import com.conversationalhub.domain.ports.out.EventPublisherPort;
import com.conversationalhub.domain.ports.out.MessageRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ChatService implements ChatUseCase {
    private final ChannelRepositoryPort channelRepository;
    private final MessageRepositoryPort messageRepository;
    private final EventPublisherPort eventPublisher;
    private final BotEngine botEngine;

    @Override
    public Channel createChannel(Channel channel) {
        // ... (existing logic)
        if (channel.getId() == null) {
            channel.setId(UUID.randomUUID().toString());
        }
        if (channel.getCreatedAt() == null) {
            channel.setCreatedAt(LocalDateTime.now());
        }
        Channel saved = channelRepository.save(channel);
        eventPublisher.publishEvent("chat.channel.created", saved);
        return saved;
    }

    @Override
    public List<Channel> getChannelsByTenant(String tenantId) {
        return channelRepository.findByTenantId(tenantId);
    }

    @Override
    public Message sendMessage(Message message) {
        message.setId(UUID.randomUUID().toString());
        message.setTimestamp(LocalDateTime.now());
        Message saved = messageRepository.save(message);

        // Process message through bot engine for commands
        botEngine.processMessage(saved);

        eventPublisher.publishEvent("chat.message.sent", saved);
        return saved;
    }

    @Override
    public List<Message> getMessagesByChannel(String channelId) {
        return messageRepository.findByChannelId(channelId);
    }

    @Override
    public List<Message> getMessagesSince(String userId, LocalDateTime since) {
        return messageRepository.findForUserSince(userId, since);
    }
}
