package com.learning.application.services;

import com.learning.domain.model.AdaptiveRules;
import com.learning.domain.model.Challenge;
import com.learning.domain.model.LessonSession;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

/**
 * Service responsible for generating personalized learning paths
 * based on student progress and adaptive rules.
 */
@Service
public class LearningPathGenerator {

    public List<LessonSession> generatePathForStudent(String studentId, String subjectId) {
        // Logic to calculate next lessons based on current completion
        // and adaptive triggers (e.g. if previous subject was failed)
        return List.of();
    }
}
