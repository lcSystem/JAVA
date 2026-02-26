import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/preferences_provider.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreferencesProvider>().loadPreferences();
    });
  }

  void _createGroup() {
    if (_groupNameController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Grupo "${_groupNameController.text}" creado exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
      _groupNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<PreferencesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Configuración del Chat', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Sección de Perfil y Estado
          const Text(
            'Estado del Perfil',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tu estado actual', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: prefs.userStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: ['Disponible', 'Ocupado', 'Ausente', 'Invisible'].map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getStatusColor(status),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(status),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        prefs.updatePreferences(userStatus: newValue);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Sección de Apariencia
          const Text(
            'Apariencia y UX',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SwitchListTile(
                title: const Text('Modo Burbuja Flotante', style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('Muestra el chat como un widget flotante en la esquina.'),
                value: prefs.isFloatingBubble,
                activeColor: prefs.primaryColor,
                onChanged: (val) {
                  prefs.updatePreferences(isFloatingBubble: val);
                },
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Sección de Grupos
          const Text(
            'Gestión de Canales',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Crear nuevo ChatGroup (Multiusuario)', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('Permite conversaciones con múltiples miembros de los proyectos.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _groupNameController,
                          decoration: InputDecoration(
                            hintText: 'Nombre del grupo...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _createGroup,
                        icon: const Icon(Icons.group_add),
                        label: const Text('Crear Grupo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: prefs.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuración sincronizada con el Hub.'), backgroundColor: Colors.indigo),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: prefs.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Sincronizar con Hub', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Disponible': return Colors.green;
      case 'Ocupado': return Colors.red;
      case 'Ausente': return Colors.orange;
      case 'Invisible': return Colors.grey;
      default: return Colors.green;
    }
  }
}
