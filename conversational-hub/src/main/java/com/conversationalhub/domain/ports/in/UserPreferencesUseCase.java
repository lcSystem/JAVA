package com.conversationalhub.domain.ports.in;

import com.conversationalhub.domain.entities.UserPreferences;

public interface UserPreferencesUseCase {
    UserPreferences savePreferences(UserPreferences preferences);

    UserPreferences getPreferences(String userId);
}
