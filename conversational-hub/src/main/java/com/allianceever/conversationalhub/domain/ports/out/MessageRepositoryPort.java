package com.allianceever.conversationalhub.domain.ports.out;

import com.allianceever.conversationalhub.domain.entities.Message;
import java.util.List;

public interface MessageRepositoryPort {
    Message save(Message message);

    List<Message> findByChannelId(String channelId);

    List<Message> findForUserSince(String userId, java.time.LocalDateTime since);
}
