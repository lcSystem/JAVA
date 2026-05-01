import 'package:flutter/material.dart';

class Session {
  final String id;
  final String studentId;
  int currentChallengeIndex;
  int heartsRemaining;
  int xpEarned;
  bool isFinished;

  Session({
    required this.id,
    required this.studentId,
    this.currentChallengeIndex = 0,
    this.heartsRemaining = 5,
    this.xpEarned = 0,
    this.isFinished = false,
  });
}
