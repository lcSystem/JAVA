package com.learning.application.ports.in;

import com.learning.domain.model.Challenge;

public interface GetNextChallengeUseCase {
    Challenge getNextChallenge(String sessionId);
}
