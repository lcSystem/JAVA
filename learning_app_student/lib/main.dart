import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/learning/presentation/controllers/lesson_controller.dart';
import 'features/learning/presentation/pages/learning_path_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LessonController()),
      ],
      child: const LearningApp(),
    ),
  );
}

class LearningApp extends StatelessWidget {
  const LearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamified K-12 Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF58CC02)),
        useMaterial3: true,
      ),
      home: const LearningPathPage(),
    );
  }
}
