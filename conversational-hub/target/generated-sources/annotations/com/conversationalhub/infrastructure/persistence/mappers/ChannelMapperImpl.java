package com.conversationalhub.infrastructure.persistence.mappers;

import com.conversationalhub.domain.entities.Channel;
import com.conversationalhub.infrastructure.persistence.entities.ChannelEntity;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-03-02T20:24:42-0500",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 21.0.10 (Ubuntu)"
)
@Component
public class ChannelMapperImpl implements ChannelMapper {

    @Override
    public Channel toDomain(ChannelEntity entity) {
        if ( entity == null ) {
            return null;
        }

        Channel.ChannelBuilder channel = Channel.builder();

        channel.id( entity.getId() );
        channel.tenantId( entity.getTenantId() );
        channel.name( entity.getName() );
        channel.description( entity.getDescription() );
        channel.erpEntityId( entity.getErpEntityId() );
        channel.erpEntityType( entity.getErpEntityType() );
        channel.createdAt( entity.getCreatedAt() );

        return channel.build();
    }

    @Override
    public ChannelEntity toEntity(Channel domain) {
        if ( domain == null ) {
            return null;
        }

        ChannelEntity.ChannelEntityBuilder channelEntity = ChannelEntity.builder();

        channelEntity.id( domain.getId() );
        channelEntity.tenantId( domain.getTenantId() );
        channelEntity.name( domain.getName() );
        channelEntity.description( domain.getDescription() );
        channelEntity.erpEntityId( domain.getErpEntityId() );
        channelEntity.erpEntityType( domain.getErpEntityType() );
        channelEntity.createdAt( domain.getCreatedAt() );

        return channelEntity.build();
    }
}
