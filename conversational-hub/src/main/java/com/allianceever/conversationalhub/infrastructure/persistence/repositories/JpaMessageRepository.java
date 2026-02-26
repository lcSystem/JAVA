package com.allianceever.conversationalhub.infrastructure.persistence.repositories;

import com.allianceever.conversationalhub.infrastructure.persistence.entities.MessageEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface JpaMessageRepository extends JpaRepository<MessageEntity, String> {
    List<MessageEntity> findByChannelId(String channelId);

    @org.springframework.data.jpa.repository.Query("SELECT m FROM MessageEntity m WHERE (m.senderId = :userId OR m.recipientId = :userId) AND m.timestamp > :since ORDER BY m.timestamp ASC")
    List<MessageEntity> findForUserSince(String userId, java.time.LocalDateTime since);
}
