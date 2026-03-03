package com.conversationalhub.infrastructure.persistence.repositories;

import com.conversationalhub.infrastructure.persistence.entities.UserChannelPreferenceEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface JpaUserChannelPreferenceRepository
        extends JpaRepository<UserChannelPreferenceEntity, UserChannelPreferenceEntity.UserChannelPreferenceId> {
    List<UserChannelPreferenceEntity> findByUserId(String userId);
}
