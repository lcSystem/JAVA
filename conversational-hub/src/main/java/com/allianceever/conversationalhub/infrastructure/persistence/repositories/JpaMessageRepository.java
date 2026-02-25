package com.allianceever.conversationalhub.infrastructure.persistence.repositories;

import com.allianceever.conversationalhub.infrastructure.persistence.entities.MessageEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface JpaMessageRepository extends JpaRepository<MessageEntity, String> {
    List<MessageEntity> findByChannelId(String channelId);
}
