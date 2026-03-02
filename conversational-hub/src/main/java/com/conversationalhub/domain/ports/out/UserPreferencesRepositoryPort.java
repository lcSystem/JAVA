package com.conversationalhub.domain.ports.out;

import com.conversationalhub.domain.entities.UserPreferences;
import java.util.Optional;

public interface UserPreferencesRepositoryPort {
    UserPreferences save(UserPreferences preferences);

    Optional<UserPreferences> findByUserId(String userId);
}
