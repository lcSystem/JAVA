package com.allianceever.conversationalhub.domain.ports.in;

import com.allianceever.conversationalhub.domain.entities.Channel;
import com.allianceever.conversationalhub.domain.entities.Message;

import java.util.List;

public interface ChatUseCase {
    Channel createChannel(Channel channel);

    List<Channel> getChannelsByTenant(String tenantId);

    Message sendMessage(Message message);

    List<Message> getMessagesByChannel(String channelId);

    List<Message> getMessagesSince(String userId, java.time.LocalDateTime since);
}
