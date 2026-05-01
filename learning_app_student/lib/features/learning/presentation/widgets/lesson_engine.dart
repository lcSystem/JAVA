import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/lesson_controller.dart';
import '../controllers/lesson_state.dart';
import '../widgets/challenge_renderer.dart';

class LessonEngineView extends StatelessWidget {
  const LessonEngineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LessonController>(context);
    final state = controller.state;

    if (state.status == LessonStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.status == LessonStatus.failed || state.status == LessonStatus.completed) {
      return _buildFinishedScreen(context, state);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: LinearProgressIndicator(
          value: state.progress,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                Text(' ${state.currentHearts}'),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ChallengeRenderer(
          challenge: const {'type': 'MULTIPLE_CHOICE', 'question': '¿Cuánto es 2 + 2?'},
          onAnswerSubmit: (answer) {
            controller.submitAnswer(answer);
          },
        ),
      ),
    );
  }

  Widget _buildFinishedScreen(BuildContext context, LessonSessionState state) {
    final isSuccess = state.status == LessonStatus.completed || state.currentHearts > 0;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSuccess ? Icons.stars : Icons.heart_broken,
              size: 100,
              color: isSuccess ? Colors.orange : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              isSuccess ? "¡Lección Completada!" : "¡Oh no! Te quedaste sin vidas",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("XP Ganado: ${state.currentXp}"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Continuar"),
            )
          ],
        ),
      ),
    );
  }
}
