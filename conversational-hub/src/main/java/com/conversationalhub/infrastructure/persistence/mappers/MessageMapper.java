package com.conversationalhub.infrastructure.persistence.mappers;

import com.conversationalhub.domain.entities.Message;
import com.conversationalhub.infrastructure.persistence.entities.MessageEntity;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Map;

@Mapper(componentModel = "spring", unmappedTargetPolicy = org.mapstruct.ReportingPolicy.IGNORE)
public abstract class MessageMapper {

    @Autowired
    protected ObjectMapper objectMapper;

    @Mapping(target = "metadata", source = "metadata", qualifiedByName = "jsonToMap")
    public abstract Message toDomain(MessageEntity entity);

    @Mapping(target = "metadata", source = "metadata", qualifiedByName = "mapToJson")
    public abstract MessageEntity toEntity(Message domain);

    @Named("jsonToMap")
    protected Map<String, Object> jsonToMap(String json) {
        if (json == null || json.isEmpty())
            return null;
        try {
            return objectMapper.readValue(json, new TypeReference<Map<String, Object>>() {
            });
        } catch (JsonProcessingException e) {
            return null;
        }
    }

    @Named("mapToJson")
    protected String mapToJson(Map<String, Object> map) {
        if (map == null)
            return null;
        try {
            return objectMapper.writeValueAsString(map);
        } catch (JsonProcessingException e) {
            return null;
        }
    }
}
