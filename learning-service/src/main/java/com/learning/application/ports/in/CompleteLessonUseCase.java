package com.learning.application.ports.in;

import com.learning.domain.model.LessonProgress;

public interface CompleteLessonUseCase {
    LessonProgress completeLesson(String sessionId);
}
