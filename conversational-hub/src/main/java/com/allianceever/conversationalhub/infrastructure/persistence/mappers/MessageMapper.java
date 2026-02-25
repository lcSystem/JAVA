package com.allianceever.conversationalhub.infrastructure.persistence.mappers;

import com.allianceever.conversationalhub.domain.entities.Message;
import com.allianceever.conversationalhub.infrastructure.persistence.entities.MessageEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface MessageMapper {
    Message toDomain(MessageEntity entity);

    MessageEntity toEntity(Message domain);
}
