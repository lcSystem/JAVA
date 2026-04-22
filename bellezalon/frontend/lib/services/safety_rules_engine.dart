import '../models/technical_sheet_models.dart';

class SafetyRulesEngine {
  // Production-Grade: Data-driven rules set
  static final List<Map<String, dynamic>> _rules = [
    {
      'condition': {'type': 'allergy', 'value': 'Amoníaco'},
      'conflict': {'type': 'chemical', 'value': 'ammoniac'},
      'action': 'block',
      'message': '🛑 CRÍTICO: Cliente alérgico al Amoníaco. El servicio seleccionado no es apto.'
    },
    {
      'condition': {'type': 'hair_status', 'value': 'quebradizo'},
      'conflict': {'type': 'service_type', 'value': 'decoloración'},
      'action': 'warn',
      'message': '⚠️ ADVERTENCIA: Cabello demasiado frágil para procesos agresivos.'
    }
  ];

  static List<String> validate(TechnicalSheet sheet, Map<String, dynamic>? selectedService) {
    List<String> alerts = [];
    if (selectedService == null) return alerts;

    final allergies = List<String>.from(sheet.dermatology['allergies'] ?? []);
    final hairStatus = sheet.hair['status'] ?? 'natural';

    for (var rule in _rules) {
      final cond = rule['condition'];
      final conflict = rule['conflict'];

      bool isMatch = false;
      if (cond['type'] == 'allergy') isMatch = allergies.contains(cond['value']);
      if (cond['type'] == 'hair_status') isMatch = hairStatus == cond['value'];

      if (isMatch) {
        final serviceName = (selectedService['nombre'] ?? '').toString().toLowerCase();
        final description = (selectedService['descripcion'] ?? '').toString().toLowerCase();

        bool isConflict = false;
        if (conflict['type'] == 'chemical') {
          isConflict = description.contains(conflict['value']) || serviceName.contains('tinte');
        }
        if (conflict['type'] == 'service_type') {
          isConflict = serviceName.contains(conflict['value']);
        }

        if (isConflict) alerts.add(rule['message']);
      }
    }

    return alerts;
  }
}
