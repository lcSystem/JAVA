package com.conversationalhub.infrastructure.persistence.mappers;

import com.conversationalhub.domain.entities.UserPreferences;
import com.conversationalhub.infrastructure.persistence.entities.UserPreferencesEntity;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2026-03-02T20:24:42-0500",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 21.0.10 (Ubuntu)"
)
@Component
public class UserPreferencesMapperImpl implements UserPreferencesMapper {

    @Override
    public UserPreferences toDomain(UserPreferencesEntity entity) {
        if ( entity == null ) {
            return null;
        }

        UserPreferences.UserPreferencesBuilder userPreferences = UserPreferences.builder();

        userPreferences.userId( entity.getUserId() );
        userPreferences.chatColor( entity.getChatColor() );
        userPreferences.themeMode( entity.getThemeMode() );

        return userPreferences.build();
    }

    @Override
    public UserPreferencesEntity toEntity(UserPreferences domain) {
        if ( domain == null ) {
            return null;
        }

        UserPreferencesEntity.UserPreferencesEntityBuilder userPreferencesEntity = UserPreferencesEntity.builder();

        userPreferencesEntity.userId( domain.getUserId() );
        userPreferencesEntity.chatColor( domain.getChatColor() );
        userPreferencesEntity.themeMode( domain.getThemeMode() );

        return userPreferencesEntity.build();
    }
}
