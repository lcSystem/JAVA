import 'package:flutter/material.dart';

class ModuleDetailPage extends StatefulWidget {
  final Map<String, dynamic> subject;
  const ModuleDetailPage({super.key, required this.subject});

  @override
  State<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1CB0F6),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1CB0F6),
          tabs: const [
            Tab(text: "UNIDADES"),
            Tab(text: "PREGUNTAS"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUnitsTab(),
          _buildQuestionsTab(),
        ],
      ),
    );
  }

  Widget _buildUnitsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_tree_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("Gestiona las unidades aquí"),
          ElevatedButton(onPressed: () {}, child: const Text("Añadir Unidad")),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildQuestionItem("¿Cuánto es 2 + 2?", "Tiempo: 15s"),
        _buildQuestionItem("Resuelve x + 5 = 10", "Tiempo: 30s"),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _showAddQuestionDialog(),
          icon: const Icon(Icons.add_task),
          label: const Text("CREAR PREGUNTA"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF58CC02),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionItem(String title, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time),
        trailing: const Icon(Icons.edit, size: 20),
      ),
    );
  }

  void _showAddQuestionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nueva Pregunta", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: "Pregunta")),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: "Tiempo (segundos)", hintText: "Ej: 30")),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("GUARDAR PREGUNTA"),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
