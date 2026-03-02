package com.conversationalhub.infrastructure.persistence.mappers;

import com.conversationalhub.domain.entities.Channel;
import com.conversationalhub.infrastructure.persistence.entities.ChannelEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ChannelMapper {
    Channel toDomain(ChannelEntity entity);

    ChannelEntity toEntity(Channel domain);
}
