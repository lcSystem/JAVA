import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/offline_guard.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  final api = ApiService();
  List<dynamic> _roles = [];
  List<dynamic> _filtrados = [];
  List<dynamic> _modules = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _loading = true);
    final roles = await api.getRoles();
    final modules = await api.getModules();
    setState(() {
      _roles = roles;
      _filtrados = List.from(roles);
      _modules = modules;
      _loading = false;
    });
    _searchCtrl.clear();
  }

  void _filter(String query) {
    setState(() {
      _filtrados = _roles.where((r) =>
        (r['name'] ?? '').toString().toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  void _showRoleForm([dynamic role]) {
    final nameController = TextEditingController(text: role?['name'] ?? '');
    final descController = TextEditingController(text: role?['description'] ?? '');
    List<int> selectedModuleIds = [];
    
    if (role != null && role['modules'] != null) {
      selectedModuleIds = List<int>.from(role['modules'].map((m) => m['id']));
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(role == null ? 'Nuevo Rol' : 'Editar Rol'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre del Rol')),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Descripción')),
                const SizedBox(height: 20),
                const Text('Permisos por Módulo:', style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),
                ..._modules.map((m) {
                  final mId = m['id'] as int;
                  return CheckboxListTile(
                    title: Text(m['name']),
                    value: selectedModuleIds.contains(mId),
                    onChanged: (val) {
                      setDialogState(() {
                        if (val == true) selectedModuleIds.add(mId);
                        else selectedModuleIds.remove(mId);
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          actions: [
            if (role != null && role['id'] != 1 && role['id'] != 2 && role['id'] != 3) // Prevent deleting default roles
              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Confirmar Eliminación'),
                      content: const Text('¿Estás seguro de que deseas eliminar este rol?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    try {
                      await api.deleteRole(role['id']);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      _fetchData();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rol eliminado')));
                    } on OfflineException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]), backgroundColor: Colors.red[700]));
                    }
                  }
                },
              ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  'name': nameController.text,
                  'description': descController.text,
                  'module_ids': selectedModuleIds,
                };
                bool success;
                try {
                if (role == null) {
                  success = await api.createRole(data);
                } else {
                  success = await api.updateRole(role['id'], data);
                }
                
                if (success) {
                  Navigator.pop(context);
                  _fetchData();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guardado correctamente')));
                }
                } on OfflineException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]), backgroundColor: Colors.red[700]));
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRoleForm(),
        backgroundColor: primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _filter,
                  decoration: InputDecoration(hintText: 'Buscar rol...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]),
                ),
              ),
              Expanded(
                child: _filtrados.isEmpty
                  ? const Center(child: Text('No se encontraron roles', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filtrados.length,
                      itemBuilder: (context, index) {
                        final r = _filtrados[index];
                        final moduleNames = (r['modules'] as List).map((m) => m['name']).join(', ');
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            title: Text(r['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (r['description'] != null && r['description'].isNotEmpty)
                                  Text(r['description'], style: const TextStyle(fontStyle: FontStyle.italic)),
                                const SizedBox(height: 4),
                                Text('Módulos: $moduleNames', style: TextStyle(color: Colors.blueGrey[600], fontSize: 13)),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, color: primary),
                              onPressed: () => _showRoleForm(r),
                            ),
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
    );
  }
}
