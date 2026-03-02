package com.allianceever.conversationalhub.infrastructure.persistence.mappers;

import com.allianceever.conversationalhub.domain.entities.Message;
import com.allianceever.conversationalhub.infrastructure.persistence.entities.MessageEntity;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-02-28T21:17:12-0500",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.45.0.v20260128-0750, environment: Java 21.0.9 (Eclipse Adoptium)"
)
@Component
public class MessageMapperImpl extends MessageMapper {

    @Override
    public Message toDomain(MessageEntity entity) {
        if ( entity == null ) {
            return null;
        }

        Message.MessageBuilder message = Message.builder();

        message.metadata( jsonToMap( entity.getMetadata() ) );
        message.channelId( entity.getChannelId() );
        message.content( entity.getContent() );
        message.id( entity.getId() );
        message.recipientId( entity.getRecipientId() );
        message.senderId( entity.getSenderId() );
        message.timestamp( entity.getTimestamp() );
        if ( entity.getType() != null ) {
            message.type( Enum.valueOf( Message.MessageType.class, entity.getType() ) );
        }

        return message.build();
    }

    @Override
    public MessageEntity toEntity(Message domain) {
        if ( domain == null ) {
            return null;
        }

        MessageEntity.MessageEntityBuilder messageEntity = MessageEntity.builder();

        messageEntity.metadata( mapToJson( domain.getMetadata() ) );
        messageEntity.channelId( domain.getChannelId() );
        messageEntity.content( domain.getContent() );
        messageEntity.id( domain.getId() );
        messageEntity.recipientId( domain.getRecipientId() );
        messageEntity.senderId( domain.getSenderId() );
        messageEntity.timestamp( domain.getTimestamp() );
        if ( domain.getType() != null ) {
            messageEntity.type( domain.getType().name() );
        }

        return messageEntity.build();
    }
}
