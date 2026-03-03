package com.conversationalhub.infrastructure.persistence.mappers;

import com.conversationalhub.domain.entities.Message;
import com.conversationalhub.infrastructure.persistence.entities.MessageEntity;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-03-02T20:24:42-0500",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 21.0.10 (Ubuntu)"
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
        message.id( entity.getId() );
        message.channelId( entity.getChannelId() );
        message.senderId( entity.getSenderId() );
        message.recipientId( entity.getRecipientId() );
        message.content( entity.getContent() );
        if ( entity.getType() != null ) {
            message.type( Enum.valueOf( Message.MessageType.class, entity.getType() ) );
        }
        message.timestamp( entity.getTimestamp() );

        return message.build();
    }

    @Override
    public MessageEntity toEntity(Message domain) {
        if ( domain == null ) {
            return null;
        }

        MessageEntity.MessageEntityBuilder messageEntity = MessageEntity.builder();

        messageEntity.metadata( mapToJson( domain.getMetadata() ) );
        messageEntity.id( domain.getId() );
        messageEntity.channelId( domain.getChannelId() );
        messageEntity.senderId( domain.getSenderId() );
        messageEntity.recipientId( domain.getRecipientId() );
        messageEntity.content( domain.getContent() );
        if ( domain.getType() != null ) {
            messageEntity.type( domain.getType().name() );
        }
        messageEntity.timestamp( domain.getTimestamp() );

        return messageEntity.build();
    }
}
