import 'package:flutter/material.dart';
import 'subject_creator_page.dart';
import 'unit_creator_page.dart';
import 'module_list_page.dart';

class ProfessorDashboard extends StatelessWidget {
  const ProfessorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Panel del Profesor", style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildAdminCard(
              context,
              title: "Módulos",
              subtitle: "Gestión de Materias",
              icon: Icons.grid_view_rounded,
              color: const Color(0xFF58CC02),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ModuleListPage())),
            ),
            _buildAdminCard(
              context,
              title: "Lecciones",
              subtitle: "Planificar contenidos",
              icon: Icons.menu_book_rounded,
              color: const Color(0xFF1CB0F6),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const unit_creator_page())),
            ),
            _buildAdminCard(
              context,
              title: "Analítica",
              subtitle: "Ver progreso",
              icon: Icons.bar_chart_rounded,
              color: const Color(0xFFFFC800),
              onTap: () {},
            ),
            _buildAdminCard(
              context,
              title: "Settings",
              subtitle: "Configuración",
              icon: Icons.settings,
              color: const Color(0xFFCE82FF),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 40),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
