import 'package:flutter/material.dart';
import '../../data/repositories/learning_repository.dart';

class SubjectCreatorPage extends StatefulWidget {
  const SubjectCreatorPage({super.key});

  @override
  State<SubjectCreatorPage> createState() => _SubjectCreatorPageState();
}

class _SubjectCreatorPageState extends State<SubjectCreatorPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repository = LearningRepository();
  bool _isSaving = false;

  void _saveSubject() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isSaving = true);
    final success = await _repository.createSubject(
      _nameController.text,
      _descriptionController.text,
    );
    setState(() => _isSaving = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Módulo creado exitosamente")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Crear Nuevo Módulo", style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Título de la Materia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Ej: Matemáticas Avanzadas",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Descripción", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Contenido curricular...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1CB0F6),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _isSaving ? null : _saveSubject,
              child: _isSaving 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("GUARDAR EN BASE DE DATOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
