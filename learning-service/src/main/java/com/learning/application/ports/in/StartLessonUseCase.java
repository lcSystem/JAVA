package com.learning.application.ports.in;

import com.learning.domain.model.LessonSession;

public interface StartLessonUseCase {
    LessonSession startLesson(String studentId, String lessonId);
}
