import 'package:flutter/foundation.dart';
import 'lesson_state.dart';

class LessonController extends ChangeNotifier {
  LessonSessionState _state = const LessonSessionState();

  LessonSessionState get state => _state;

  void startLesson(String lessonDefinitionId) {
    _state = _state.copyWith(status: LessonStatus.loading);
    notifyListeners();

    // Simulating API call
    Future.delayed(const Duration(seconds: 1), () {
      _state = _state.copyWith(status: LessonStatus.inProgress);
      notifyListeners();
    });
  }

  void submitAnswer(String answer) {
    _state = _state.copyWith(status: LessonStatus.evaluatingAnswer);
    notifyListeners();

    // Mock verification logic
    Future.delayed(const Duration(milliseconds: 500), () {
      bool isCorrect = answer == "4"; // Simple mock check
      
      if (isCorrect) {
        _state = _state.copyWith(
          status: LessonStatus.inProgress, 
          currentXp: _state.currentXp + 15,
          progress: _state.progress + 0.1,
        );
      } else {
        final newHearts = _state.currentHearts - 1;
        _state = _state.copyWith(
          currentHearts: newHearts,
          status: newHearts > 0 ? LessonStatus.inProgress : LessonStatus.failed
        );
      }
      notifyListeners();
    });
  }
}
