package com.allianceever.conversationalhub.infrastructure.persistence.mappers;

import com.allianceever.conversationalhub.domain.entities.Channel;
import com.allianceever.conversationalhub.infrastructure.persistence.entities.ChannelEntity;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-02-25T01:16:10-0500",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.45.0.v20260128-0750, environment: Java 21.0.9 (Eclipse Adoptium)"
)
@Component
public class ChannelMapperImpl implements ChannelMapper {

    @Override
    public Channel toDomain(ChannelEntity entity) {
        if ( entity == null ) {
            return null;
        }

        Channel.ChannelBuilder channel = Channel.builder();

        channel.createdAt( entity.getCreatedAt() );
        channel.description( entity.getDescription() );
        channel.erpEntityId( entity.getErpEntityId() );
        channel.erpEntityType( entity.getErpEntityType() );
        channel.id( entity.getId() );
        channel.name( entity.getName() );
        channel.tenantId( entity.getTenantId() );

        return channel.build();
    }

    @Override
    public ChannelEntity toEntity(Channel domain) {
        if ( domain == null ) {
            return null;
        }

        ChannelEntity.ChannelEntityBuilder channelEntity = ChannelEntity.builder();

        channelEntity.createdAt( domain.getCreatedAt() );
        channelEntity.description( domain.getDescription() );
        channelEntity.erpEntityId( domain.getErpEntityId() );
        channelEntity.erpEntityType( domain.getErpEntityType() );
        channelEntity.id( domain.getId() );
        channelEntity.name( domain.getName() );
        channelEntity.tenantId( domain.getTenantId() );

        return channelEntity.build();
    }
}
