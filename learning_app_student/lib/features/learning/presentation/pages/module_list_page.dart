import 'package:flutter/material.dart';
import '../../data/repositories/learning_repository.dart';
import 'subject_creator_page.dart';
import 'module_detail_page.dart';

class ModuleListPage extends StatefulWidget {
  const ModuleListPage({super.key});

  @override
  State<ModuleListPage> createState() => _ModuleListPageState();
}

class _ModuleListPageState extends State<ModuleListPage> {
  final _repository = LearningRepository();
  List<Map<String, dynamic>> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);
    final data = await _repository.getSubjects();
    setState(() {
      _subjects = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mis Módulos", style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF58CC02), size: 30),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectCreatorPage()));
              _loadSubjects();
            },
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _subjects.length,
            itemBuilder: (context, index) {
              final subject = _subjects[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(subject['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(subject['description'] ?? 'Sin descripción'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleDetailPage(subject: subject)));
                  },
                ),
              );
            },
          ),
    );
  }
}
