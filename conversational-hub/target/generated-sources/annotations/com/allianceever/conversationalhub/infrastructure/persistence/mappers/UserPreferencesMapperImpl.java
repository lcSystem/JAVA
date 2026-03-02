package com.allianceever.conversationalhub.infrastructure.persistence.mappers;

import com.allianceever.conversationalhub.domain.entities.UserPreferences;
import com.allianceever.conversationalhub.infrastructure.persistence.entities.UserPreferencesEntity;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-02-28T21:17:11-0500",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.45.0.v20260128-0750, environment: Java 21.0.9 (Eclipse Adoptium)"
)
@Component
public class UserPreferencesMapperImpl implements UserPreferencesMapper {

    @Override
    public UserPreferences toDomain(UserPreferencesEntity entity) {
        if ( entity == null ) {
            return null;
        }

        UserPreferences.UserPreferencesBuilder userPreferences = UserPreferences.builder();

        userPreferences.chatColor( entity.getChatColor() );
        userPreferences.themeMode( entity.getThemeMode() );
        userPreferences.userId( entity.getUserId() );

        return userPreferences.build();
    }

    @Override
    public UserPreferencesEntity toEntity(UserPreferences domain) {
        if ( domain == null ) {
            return null;
        }

        UserPreferencesEntity.UserPreferencesEntityBuilder userPreferencesEntity = UserPreferencesEntity.builder();

        userPreferencesEntity.chatColor( domain.getChatColor() );
        userPreferencesEntity.themeMode( domain.getThemeMode() );
        userPreferencesEntity.userId( domain.getUserId() );

        return userPreferencesEntity.build();
    }
}
