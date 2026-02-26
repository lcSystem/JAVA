package com.allianceever.conversationalhub.domain.ports.in;

import com.allianceever.conversationalhub.domain.entities.UserPreferences;

public interface UserPreferencesUseCase {
    UserPreferences savePreferences(UserPreferences preferences);

    UserPreferences getPreferences(String userId);
}
