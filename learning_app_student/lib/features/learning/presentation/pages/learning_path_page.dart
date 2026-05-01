import 'package:flutter/material.dart';
import '../widgets/learning_path_node.dart';
import '../widgets/lesson_engine.dart';
import '../controllers/lesson_controller.dart';
import 'package:provider/provider.dart';
import 'professor_dashboard.dart';

class LearningPathPage extends StatefulWidget {
  const LearningPathPage({super.key});

  @override
  State<LearningPathPage> createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage> {
  
  // To be fetched from API
  final List<Map<String, dynamic>> _mockUnits = [
    {"id": "u1", "title": "Suma y Resta", "isCompleted": true, "isLocked": false},
    {"id": "u2", "title": "Fracciones", "isCompleted": false, "isLocked": false},
    {"id": "u3", "title": "Decimales", "isCompleted": false, "isLocked": true},
    {"id": "u4", "title": "Álgebra Lineal", "isCompleted": false, "isLocked": true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: _buildAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF58CC02)),
              child: Text('EDTECH K-12', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Modo Estudiante'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Modo Profesor'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfessorDashboard()));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              ..._buildPath(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Matemáticas - 6° Grado", 
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF3C3C3C))),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      shape: const Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 2)),
      actions: [
        _buildXpBadge(),
      ],
    );
  }

  Widget _buildXpBadge() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC800),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: const Color(0xFFC79E00), offset: const Offset(0, 4), blurRadius: 0),
        ],
      ),
      child: const Center(
        child: Text("125 XP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
      ),
    );
  }

  List<Widget> _buildPath() {
    List<Widget> nodes = [];
    for (int i = 0; i < _mockUnits.length; i++) {
      final unit = _mockUnits[i];
      
      // Calculate horizontal offset for zigzag effect
      double horizontalPadding = 0;
      if (i % 4 == 1) horizontalPadding = 40;
      if (i % 4 == 2) horizontalPadding = 60;
      if (i % 4 == 3) horizontalPadding = 40;

      nodes.add(
        Padding(
          padding: EdgeInsets.only(left: horizontalPadding),
          child: LearningPathNode(
            title: unit['title'],
            isCompleted: unit['isCompleted'],
            isLocked: unit['isLocked'],
            onTap: () => _startLesson(context, unit['id']),
          ),
        ),
      );
      if (i < _mockUnits.length - 1) {
        nodes.add(
          Padding(
            padding: EdgeInsets.only(left: horizontalPadding > 0 ? horizontalPadding / 2 : 0),
            child: _buildConnector(unit['isCompleted']),
          ),
        );
      }
    }
    return nodes;
  }

  Widget _buildConnector(bool completed) {
    return Container(
      width: 12,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: completed ? const Color(0xFF58CC02) : const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  void _startLesson(BuildContext context, String lessonId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LessonEngineView()),
    );
  }
}
