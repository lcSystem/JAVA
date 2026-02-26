package com.allianceever.conversationalhub.domain.ports.out;

import com.allianceever.conversationalhub.domain.entities.UserPreferences;
import java.util.Optional;

public interface UserPreferencesRepositoryPort {
    UserPreferences save(UserPreferences preferences);

    Optional<UserPreferences> findByUserId(String userId);
}
