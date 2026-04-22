import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HealthProfileTab extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSave;

  const HealthProfileTab({super.key, this.initialData, required this.onSave});

  @override
  State<HealthProfileTab> createState() => _HealthProfileTabState();
}

class _HealthProfileTabState extends State<HealthProfileTab> {
  final Map<String, dynamic> _data = {
    'allergies': <String>[],
    'selected_zones': <String>[],
    'hair_status': 'natural',
    'medical_notes': '',
    'hair_elasticity': 'normal',
    'hair_porosity': 'media',
  };

  final List<String> _commonAllergies = ['PPD', 'Amoníaco', 'Látex', 'Fragancias', 'Níquel', 'Resinas'];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _data.addAll(widget.initialData!);
    }
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      final list = List<String>.from(_data['allergies'] ?? []);
      if (list.contains(allergy)) {
        list.remove(allergy);
      } else {
        list.add(allergy);
      }
      _data['allergies'] = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Mapa Técnico: Zonas Afectadas'),
          const SizedBox(height: 16),
          const Text('Toca las zonas que tengan alguna sensibilidad, quemadura o irritación actual.', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),
          Center(
            child: InteractiveBodyMap(
              selectedZones: List<String>.from(_data['selected_zones'] ?? []),
              onZoneToggle: (zone) {
                setState(() {
                  final list = List<String>.from(_data['selected_zones'] ?? []);
                  if (list.contains(zone)) {
                    list.remove(zone);
                  } else {
                    list.add(zone);
                  }
                  _data['selected_zones'] = list;
                });
              },
            ),
          ),
          const SizedBox(height: 32),
          _buildHeader('Alergias y Sensibilidades'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _commonAllergies.map((a) {
              final selected = (_data['allergies'] as List).contains(a);
              return FilterChip(
                label: Text(a),
                selected: selected,
                selectedColor: primary.withOpacity(0.2),
                checkmarkColor: primary,
                onSelected: (_) => _toggleAllergy(a),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _buildHeader('Estado Capilar (Experto)'),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _data['hair_status'],
            decoration: const InputDecoration(labelText: 'Condición General', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'natural', child: Text('Natural / Virgen')),
              DropdownMenuItem(value: 'procesado', child: Text('Procesado Químicamente')),
              DropdownMenuItem(value: 'quebradizo', child: Text('Quebradizo / Dañado')),
              DropdownMenuItem(value: 'poroso', child: Text('Muy Poroso')),
            ],
            onChanged: (v) => setState(() => _data['hair_status'] = v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _data['hair_elasticity'],
                  decoration: const InputDecoration(labelText: 'Elasticidad', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'baja', child: Text('Baja')),
                    DropdownMenuItem(value: 'normal', child: Text('Normal')),
                    DropdownMenuItem(value: 'buena', child: Text('Buena')),
                  ],
                  onChanged: (v) => setState(() => _data['hair_elasticity'] = v),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _data['hair_porosity'],
                  decoration: const InputDecoration(labelText: 'Porosidad', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'baja', child: Text('Baja')),
                    DropdownMenuItem(value: 'media', child: Text('Media')),
                    DropdownMenuItem(value: 'alta', child: Text('Alta')),
                  ],
                  onChanged: (v) => setState(() => _data['hair_porosity'] = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildHeader('Notas Médicas / Observaciones'),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _data['medical_notes'],
            decoration: const InputDecoration(
              labelText: 'Detalla condiciones como eccemas, quemaduras recientes, etc.',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            onChanged: (v) => _data['medical_notes'] = v,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: () => widget.onSave(_data),
              icon: const Icon(Icons.verified_user),
              label: const Text('Actualizar Ficha Técnica'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }
}

class InteractiveBodyMap extends StatelessWidget {
  final List<String> selectedZones;
  final Function(String) onZoneToggle;

  const InteractiveBodyMap({super.key, required this.selectedZones, required this.onZoneToggle});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    
    return Container(
      width: 280,
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Stack(
        children: [
          Center(child: Icon(Icons.person, size: 300, color: Colors.grey[200])),
          // Zones (Simulated with absolute positions for simplicity in MVP, 
          // in a full production app we'd use an SVG Parser)
          _buildZone(top: 20, left: 115, icon: Icons.face, id: 'cabeza', label: 'Cabeza'),
          _buildZone(top: 100, left: 115, icon: Icons.accessibility, id: 'torso', label: 'Torso'),
          _buildZone(top: 80, left: 60, icon: Icons.pan_tool, id: 'mano_izq', label: 'Mano I'),
          _buildZone(top: 80, left: 170, icon: Icons.pan_tool, id: 'mano_der', label: 'Mano D'),
          _buildZone(top: 60, left: 115, icon: Icons.colorize, id: 'cuello', label: 'Cuello'),
          _buildZone(top: 250, left: 90, icon: Icons.reorder, id: 'piernas', label: 'Piernas'),
        ],
      ),
    );
  }

  Widget _buildZone({required double top, required double left, required IconData icon, required String id, required String label}) {
    final isSelected = selectedZones.contains(id);
    return Positioned(
      top: top,
      left: left,
      child: Tooltip(
        message: label,
        child: GestureDetector(
          onTap: () => onZoneToggle(id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.red.withOpacity(0.4) : Colors.transparent,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.red, width: 2) : null,
            ),
            child: Icon(icon, color: isSelected ? Colors.red : Colors.grey[400], size: 32),
          ),
        ),
      ),
    );
  }
}
