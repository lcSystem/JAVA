import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/offline_guard.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final api = ApiService();
  List<dynamic> _users = [];
  List<dynamic> _filtrados = [];
  List<dynamic> _roles = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();
  int? _filterRoleId;

  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() { _loading = true; _errorMsg = null; });
    try {
      final users = await api.getUsers();
      final roles = await api.getRoles();
      debugPrint('[UsersScreen] Usuarios recibidos: ${users.length}, Roles: ${roles.length}');
      if (users.isEmpty) {
        debugPrint('[UsersScreen] ADVERTENCIA: Lista de usuarios vacía. Puede ser un problema de permisos o base de datos.');
      }
      setState(() {
        _users = users;
        _filtrados = List.from(users);
        _roles = roles;
        _loading = false;
      });
    } catch (e) {
      debugPrint('[UsersScreen] Error cargando usuarios: $e');
      setState(() {
        _loading = false;
        _errorMsg = 'Error al cargar usuarios: $e';
      });
    }
    _searchCtrl.clear();
  }

  void _filter() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtrados = _users.where((u) {
        final matchesText = (u['username'] ?? '').toString().toLowerCase().contains(query) ||
                            (u['full_name'] ?? '').toString().toLowerCase().contains(query) ||
                            (u['role_name'] ?? '').toString().toLowerCase().contains(query);
        final matchesRole = _filterRoleId == null || u['role_id'] == _filterRoleId;
        return matchesText && matchesRole;
      }).toList();
    });
  }

  void _showUserForm([dynamic user]) {
    final usernameController = TextEditingController(text: user?['username'] ?? '');
    final passwordController = TextEditingController();
    final fullNameController = TextEditingController(text: user?['full_name'] ?? '');
    final emailController = TextEditingController(text: user?['email'] ?? '');
    final phoneController = TextEditingController(text: user?['phone'] ?? '');
    int? selectedRoleId = user?['role_id'];
    String selectedEstado = user?['estado'] ?? 'activo';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(user == null ? Icons.person_add : Icons.edit, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(user == null ? 'Nuevo Usuario' : 'Editar Usuario'),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre Completo',
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Teléfono',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de usuario',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: user == null ? 'Contraseña' : 'Nueva contraseña (dejar vacío para mantener)',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedRoleId,
                    decoration: InputDecoration(
                      labelText: 'Rol asignado',
                      prefixIcon: const Icon(Icons.admin_panel_settings),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _roles.map<DropdownMenuItem<int>>((r) {
                      return DropdownMenuItem<int>(
                        value: r['id'] as int,
                        child: Text(r['name']),
                      );
                    }).toList(),
                    onChanged: (val) => setDialogState(() => selectedRoleId = val),
                  ),
                  if (selectedRoleId != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Módulos del rol:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Builder(builder: (ctx) {
                            final role = _roles.firstWhere((r) => r['id'] == selectedRoleId, orElse: () => null);
                            if (role == null) return const Text('Rol no encontrado');
                            final modules = role['modules'] as List? ?? [];
                            if (modules.isEmpty) return const Text('Sin módulos asignados', style: TextStyle(color: Colors.grey));
                            return Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: modules.map<Widget>((m) => Chip(
                                label: Text(m['name'], style: const TextStyle(fontSize: 11)),
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              )).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedEstado,
                    decoration: InputDecoration(
                      labelText: 'Estado',
                      prefixIcon: Icon(selectedEstado == 'activo' ? Icons.check_circle : Icons.cancel, color: selectedEstado == 'activo' ? Colors.green : Colors.red),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'activo', child: Text('Activo')),
                      DropdownMenuItem(value: 'inactivo', child: Text('Inactivo')),
                    ],
                    onChanged: (val) => setDialogState(() => selectedEstado = val!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            if (user != null)
              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Confirmar Eliminación'),
                      content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
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
                      await api.deleteUser(user['id']);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      _fetchData();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario eliminado')));
                    } on OfflineException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]), backgroundColor: Colors.red[700]));
                    }
                  }
                },
              ),
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancelar'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (usernameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El nombre de usuario es obligatorio')));
                  return;
                }
                if (user == null && passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La contraseña es obligatoria')));
                  return;
                }
                if (selectedRoleId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seleccione un rol')));
                  return;
                }

                final data = <String, dynamic>{
                  'username': usernameController.text,
                  'role_id': selectedRoleId,
                  'estado': selectedEstado,
                  'full_name': fullNameController.text,
                  'phone': phoneController.text,
                  'email': emailController.text,
                };
                if (passwordController.text.isNotEmpty) {
                  data['password'] = passwordController.text;
                }

                bool success;
                try {
                if (user == null) {
                  success = await api.createUser(data);
                } else {
                  success = await api.updateUser(user['id'], data);
                }

                if (success) {
                  Navigator.pop(context);
                  _fetchData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(user == null ? 'Usuario creado exitosamente' : 'Usuario actualizado')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al guardar. El nombre de usuario puede estar duplicado.')),
                  );
                }
                } on OfflineException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]), backgroundColor: Colors.red[700]));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserForm(),
        backgroundColor: primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Nuevo Usuario', style: TextStyle(color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMsg != null
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(_errorMsg!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(icon: const Icon(Icons.refresh), label: const Text('Reintentar'), onPressed: _fetchData),
                ]))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: isMobile
                    ? Column(
                        children: [
                          TextField(
                            controller: _searchCtrl,
                            onChanged: (_) => _filter(),
                            decoration: InputDecoration(hintText: 'Buscar usuario...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<int?>(
                            value: _filterRoleId,
                            decoration: InputDecoration(
                              labelText: 'Filtrar por Rol',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            items: [
                              const DropdownMenuItem<int?>(value: null, child: Text('Todos los roles')),
                              ..._roles.map((r) => DropdownMenuItem<int?>(
                                    value: r['id'] as int,
                                    child: Text(r['name']),
                                  )),
                            ],
                            onChanged: (val) {
                              setState(() => _filterRoleId = val);
                              _filter();
                            },
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: (_) => _filter(),
                              decoration: InputDecoration(hintText: 'Buscar usuario...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50]),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<int?>(
                              value: _filterRoleId,
                              decoration: InputDecoration(
                                labelText: 'Filtrar por Rol',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              items: [
                                const DropdownMenuItem<int?>(value: null, child: Text('Todos los roles')),
                                ..._roles.map((r) => DropdownMenuItem<int?>(
                                      value: r['id'] as int,
                                      child: Text(r['name']),
                                    )),
                              ],
                              onChanged: (val) {
                                setState(() => _filterRoleId = val);
                                _filter();
                              },
                            ),
                          ),
                        ],
                      ),
                ),
                Expanded(
                  child: _filtrados.isEmpty
                      ? const Center(child: Text('No se encontraron usuarios', style: TextStyle(fontSize: 16, color: Colors.grey)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filtrados.length,
                          itemBuilder: (context, index) {
                            final u = _filtrados[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        leading: CircleAvatar(
                          backgroundColor: primary.withOpacity(0.1),
                          child: Icon(Icons.person, color: primary),
                        ),
                        title: Text(u['full_name'] != null && u['full_name'].toString().isNotEmpty ? u['full_name'] : u['username'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (u['phone'] != null && u['phone'].toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 2),
                                child: Text('📞 ${u['phone']}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              ),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    u['role_name'] ?? 'Sin rol',
                                    style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (u['estado'] == 'activo' ? Colors.green : Colors.red).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    u['estado'] == 'activo' ? 'Activo' : 'Inactivo',
                                    style: TextStyle(color: (u['estado'] == 'activo' ? Colors.green : Colors.red), fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: primary),
                          onPressed: () => _showUserForm(u),
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
