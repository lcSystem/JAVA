package com.allianceever.conversationalhub.infrastructure.persistence.repositories;

import com.allianceever.conversationalhub.infrastructure.persistence.entities.UserPreferencesEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JpaUserPreferencesRepository extends JpaRepository<UserPreferencesEntity, String> {
}
