import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/technical_sheet_models.dart';
import '../models/avatar_state_model.dart';
import '../components/realistic_avatar_engine.dart';
import '../services/safety_rules_engine.dart';
import '../services/customer_state_engine.dart';
import '../components/searchable_city_field.dart';
import '../components/avatar_studio_components.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Data
  TechnicalSheet _sheet = TechnicalSheet();
  Map<String, dynamic> _profileData = {};
  AvatarState _avatarState = AvatarState();
  bool _isLoading = true;
  bool _isSaving = false;

  // Controllers for general info
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // 1 General + 4 Twin
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _birthDateController = TextEditingController();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final data = await ApiService().getProfile();
      setState(() {
        _profileData = data;
        _nameController.text = data['full_name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        if (data['technical_sheet'] != null) {
          _sheet = TechnicalSheet.fromJson(data['technical_sheet']);
          _birthDateController.text = _sheet.userData['birth_date'] ?? '';
        } else {
          // Default init
          _sheet = TechnicalSheet();
        }
        _avatarState = AvatarState.fromTechnicalSheet(_sheet.morphology, _sheet.systemState);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAll() async {
    if (_isSaving) return; // Prevent double click

    setState(() => _isSaving = true);

    try {
      // Activate State Engine
      final updatedSheet = UnifiedStateEngine.updateState(_sheet);
      
      final body = {
        'full_name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'technical_sheet': updatedSheet.toJson(),
      };

      final ok = await ApiService().updateProfile(body);
      
      if (mounted) {
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Perfil guardado correctamente'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            )
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al guardar el perfil'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            )
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error crítico: $e'), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Digital Beauty Twin Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          if (!_isSaving)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextButton.icon(
                onPressed: _saveAll,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;
          
          if (isDesktop) {
            return Row(
              children: [
                // Left side: Immersive Avatar Studio
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(right: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: _buildAvatarStudio(),
                  ),
                ),
                // Right side: Settings & Tabs
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      _buildEngagementBanner(),
                      _buildTabMenu(),
                      Expanded(child: _buildTabContent()),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Mobile: Top Avatar, Bottom Tabs
            return Column(
              children: [
                _buildEngagementBanner(),
                SizedBox(height: 250, child: _buildAvatarStudio()),
                _buildTabMenu(),
                Expanded(child: _buildTabContent()),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildAvatarStudio() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RealisticAvatarEngine(
              state: _avatarState,
              size: 240,
            ),
            const SizedBox(height: 16),
            const Text('IDENTITY PRO ENGINE v2.0', style: TextStyle(color: Colors.blueGrey, fontSize: 13, letterSpacing: 2, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _avatarState.completeness,
                backgroundColor: Colors.grey.shade200,
                color: _avatarState.completeness == 1.0 ? Colors.green : Colors.blue,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Text(_avatarState.completeness == 1.0 ? 'DIGITAL TWIN: READY' : 'SYNCING HUMAN TRAITS...', 
              style: TextStyle(color: _avatarState.completeness == 1.0 ? Colors.green : Colors.blueGrey, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabMenu() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
        tabs: const [
          Tab(text: 'General'),
          Tab(text: 'Morfología'),
          Tab(text: 'Salud'),
          Tab(text: 'Cabello'),
          Tab(text: 'Seguridad'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildGeneralTab(),
        _buildIdentityTab(),
        _buildAffectionsTab(),
        _buildHairTab(),
        _buildSafetyTab(),
      ],
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Información General', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre Completo', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 16),
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email))),
            const SizedBox(height: 16),
            TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Número de Teléfono', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone))),
            const SizedBox(height: 24),
            
            const Text('Datos Vitales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            // Gender Selector
            const Text('Sexo / Género', style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildGenderOption('Masculino', Icons.male, Colors.blue),
                const SizedBox(width: 8),
                _buildGenderOption('Femenino', Icons.female, Colors.pink),
                const SizedBox(width: 8),
                _buildGenderOption('Otro', Icons.transgender, Colors.purple),
              ],
            ),
            const SizedBox(height: 24),

            // Birth Date
            TextFormField(
              controller: _birthDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha de Nacimiento',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
                hintText: 'YYYY-MM-DD',
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  final str = date.toString().substring(0, 10);
                  setState(() {
                    _birthDateController.text = str;
                    _sheet.userData['birth_date'] = str;
                  });
                }
              },
            ),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, IconData icon, Color color) {
    bool isSelected = _sheet.userData['gender'] == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _sheet.userData['gender'] = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? color : Colors.grey, size: 28),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: isSelected ? color : Colors.grey, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEngagementBanner() {
    final completeness = _sheet.systemState['completeness'] ?? 0.0;
    if (completeness >= 1.0) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.amber.shade100,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.stars, color: Colors.amber.shade900, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Completa tu perfil para mejor atención (${(completeness * 100).toInt()}%)',
              style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: () => _tabController.animateTo(2),
            child: const Text('Completar'),
          )
        ],
      ),
    );
  }

  Widget _buildIdentityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VISUAL HUMAN AVATAR STUDIO', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 1.2)),
                Text('Diseña tu identidad digital con rasgos humanos realistas', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SkinToneStudioPicker(
            selectedTone: _avatarState.skinTone,
            onSelected: (tone) {
              setState(() {
                _sheet.morphology['skin_tone_hex'] = tone; // Sync for DiceBear mapping
                _avatarState = _avatarState.copyWith(skinTone: tone);
              });
            },
          ),
          const SizedBox(height: 24),
          VisualAssetGallery(
            title: 'Diseño Capilar (Hair)',
            category: 'hair',
            selectedId: _avatarState.hair,
            options: VisualAssetGallery.hairOptions,
            currentState: _avatarState,
            onSelected: (id) => setState(() {
              _sheet.morphology['hair'] = id;
              _avatarState = _avatarState.copyWith(hair: id);
            }),
          ),
          const SizedBox(height: 16),
          VisualAssetGallery(
            title: 'Expresión Ocular (Eyes)',
            category: 'eyes',
            selectedId: _avatarState.eyes,
            options: VisualAssetGallery.eyeOptions,
            currentState: _avatarState,
            onSelected: (id) => setState(() {
              _sheet.morphology['eyes'] = id;
              _avatarState = _avatarState.copyWith(eyes: id);
            }),
          ),
          const SizedBox(height: 16),
          VisualAssetGallery(
            title: 'Perfil Nasal (Nose)',
            category: 'nose',
            selectedId: _avatarState.nose,
            options: VisualAssetGallery.noseOptions,
            currentState: _avatarState,
            onSelected: (id) => setState(() {
              _sheet.morphology['nose'] = id;
              _avatarState = _avatarState.copyWith(nose: id);
            }),
          ),
          const SizedBox(height: 16),
          VisualAssetGallery(
            title: 'Gesto Bucal (Mouth)',
            category: 'mouth',
            selectedId: _avatarState.mouth,
            options: VisualAssetGallery.mouthOptions,
            currentState: _avatarState,
            onSelected: (id) => setState(() {
              _sheet.morphology['mouth'] = id;
              _avatarState = _avatarState.copyWith(mouth: id);
            }),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAffectionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: _buildAffectionsSection(),
    );
  }

  Widget _buildAffectionsSection() {
    final affections = _sheet.affections;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Afectaciones & Alergias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blue),
              onPressed: _showAddAffectionDialog,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (affections.isEmpty)
          const Text('No hay registros de salud.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
        ...affections.map((a) => Card(
          child: ListTile(
            leading: Icon(
              a['type'] == 'alergy' ? Icons.warning_amber_rounded : Icons.info_outline,
              color: a['importance'] == 'high' ? Colors.red : Colors.orange,
            ),
            title: Text(a['description'] ?? ''),
            subtitle: Text('Severidad: ${a['importance']?.toString().toUpperCase()}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => _removeAffection(a),
            ),
          ),
        )),
      ],
    );
  }

  void _showAddAffectionDialog() {
    String type = 'alergy';
    String importance = 'medium';
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nueva Afectación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: type,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'alergy', child: Text('Alergia')),
                  DropdownMenuItem(value: 'sensitivity', child: Text('Sensibilidad')),
                  DropdownMenuItem(value: 'other', child: Text('Otra Condición')),
                ],
                onChanged: (v) => setDialogState(() => type = v!),
              ),
              DropdownButton<String>(
                value: importance,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Baja')),
                  DropdownMenuItem(value: 'medium', child: Text('Media')),
                  DropdownMenuItem(value: 'high', child: Text('Alta (Crítica)')),
                ],
                onChanged: (v) => setDialogState(() => importance = v!),
              ),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Descripción')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final newAff = {
                  'type': type,
                  'importance': importance,
                  'description': descController.text,
                  'status': 'active',
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                };
                setState(() {
                  _sheet.userData['modules']['affections'].add(newAff);
                  _avatarState = AvatarState.fromTechnicalSheet(_sheet.morphology, _sheet.systemState);
                });
                Navigator.pop(ctx);
              },
              child: const Text('Agregar'),
            )
          ],
        ),
      ),
    );
  }

  void _removeAffection(Map<String, dynamic> a) {
    setState(() {
      _sheet.userData['modules']['affections'].remove(a);
    });
  }


  Widget _buildHairTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Diagnóstico y Evolución', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildDropdown('Estado Capilar', 'status', ['natural', 'procesado', 'quebradizo'], _sheet.hair),
          const SizedBox(height: 32),
          const Text('Línea de Vida (Evolution Index)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...(_sheet.evolution).map((e) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.timeline, color: Colors.blue),
              title: Text(e['event'] ?? 'Servicio Realizado'),
              subtitle: Text(e['result'] ?? 'Sin cambios reportados'),
              trailing: Text(e['date'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSafetyTab() {
    final evaluation = _sheet.systemState['last_evaluation'] ?? {'decision': 'PASS', 'reasons': []};
    final decision = evaluation['decision'];
    final reasons = List<String>.from(evaluation['reasons'] ?? []);
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estado de Seguridad & Riesgo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildDecisionCard(decision, reasons),
          const SizedBox(height: 24),
          const Text('Historial de Decisiones (Audit)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.security, color: decision == 'BLOCK' ? Colors.red : Colors.green),
            title: Text('Evaluación: $decision'),
            subtitle: Text('ID Consentimiento: ${_sheet.legalState['consent']?['version'] ?? 'v1.0'}'),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionCard(String decision, List<String> reasons) {
    Color color = Colors.greenAccent;
    IconData icon = Icons.check_circle;
    String title = 'Servicio Seguro';

    if (decision == 'WARN') {
      color = Colors.orangeAccent;
      icon = Icons.warning;
      title = 'Advertencia de Seguridad';
    } else if (decision == 'BLOCK') {
      color = Colors.redAccent;
      icon = Icons.gavel;
      title = 'Servicio No Recomendado';
    }

    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: decision == 'PASS' ? Colors.black87 : Colors.white),
                const SizedBox(width: 12),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: decision == 'PASS' ? Colors.black87 : Colors.white)),
              ],
            ),
            if (reasons.isNotEmpty) ...[
              const Divider(),
              ...reasons.map((r) => Text('• $r', style: TextStyle(color: decision == 'PASS' ? Colors.black87 : Colors.white))),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String key, List<String> options, Map<String, dynamic> target) {
    return DropdownButtonFormField<String>(
      value: target[key],
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: options.map((o) => DropdownMenuItem(value: o, child: Text(o.toUpperCase()))).toList(),
      onChanged: (v) => setState(() => target[key] = v),
    );
  }
}
