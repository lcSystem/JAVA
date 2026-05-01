import 'package:flutter/foundation.dart';

enum LessonStatus {
  initial,
  loading,
  inProgress,
  evaluatingAnswer,
  completed,
  failed
}

@immutable
class LessonSessionState {
  final LessonStatus status;
  final int currentXp;
  final int currentHearts;
  final double progress;
  final String? errorMessage;

  const LessonSessionState({
    this.status = LessonStatus.initial,
    this.currentXp = 0,
    this.currentHearts = 5,
    this.progress = 0.0,
    this.errorMessage,
  });

  LessonSessionState copyWith({
    LessonStatus? status,
    int? currentXp,
    int? currentHearts,
    double? progress,
    String? errorMessage,
  }) {
    return LessonSessionState(
      status: status ?? this.status,
      currentXp: currentXp ?? this.currentXp,
      currentHearts: currentHearts ?? this.currentHearts,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
