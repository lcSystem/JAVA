package com.allianceever.conversationalhub.infrastructure.persistence.mappers;

import com.allianceever.conversationalhub.domain.entities.UserPreferences;
import com.allianceever.conversationalhub.infrastructure.persistence.entities.UserPreferencesEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring", unmappedTargetPolicy = org.mapstruct.ReportingPolicy.IGNORE)
public interface UserPreferencesMapper {
    UserPreferences toDomain(UserPreferencesEntity entity);

    UserPreferencesEntity toEntity(UserPreferences domain);
}
