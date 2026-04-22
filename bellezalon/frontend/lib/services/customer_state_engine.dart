import '../models/technical_sheet_models.dart';

class CustomerDecisionEngine {
  static Map<String, dynamic> evaluate(TechnicalSheet sheet, Map<String, dynamic> serviceContext) {
    List<String> reasons = [];
    String decision = 'PASS';

    final affections = sheet.affections;
    final serviceType = serviceContext['type'] ?? '';
    final chemicals = List<String>.from(serviceContext['chemicals'] ?? []);

    for (var aff in affections) {
      if (aff['status'] != 'active') continue;

      final importance = aff['importance'] ?? 'low';
      final desc = (aff['description'] ?? '').toLowerCase();

      // Logic: High Severity Allergies + Chemical Service = BLOCK
      if (aff['type'] == 'alergy' && importance == 'high') {
        if (chemicals.any((c) => desc.contains(c.toLowerCase())) || serviceType == 'hair_dye') {
          decision = 'BLOCK';
          reasons.add('Riesgo crítico: Alergia severa detectada para este servicio.');
        }
      }

      // Logic: Medium Severity Skin Sensitivity + Aggressive Service = WARN
      if (aff['type'] == 'sensitivity' && importance == 'medium') {
        if (serviceType == 'bleaching') {
          if (decision != 'BLOCK') decision = 'WARN';
          reasons.add('Advertencia: Sensibilidad cutánea media detectada.');
        }
      }
    }

    return {
      'decision': decision,
      'reasons': reasons,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }
}

class UnifiedStateEngine {
  static double calculateCompleteness(TechnicalSheet sheet) {
    const requiredFields = 8; // E.g., skin, face, hair, 3 affections, 2 evolution
    int filled = 0;

    if (sheet.morphology.isNotEmpty) filled += 2; // skin, face
    if (sheet.hair.isNotEmpty) filled += 1;
    if (sheet.affections.isNotEmpty) filled += 2;
    if (sheet.evolution.isNotEmpty) filled += 3;

    return (filled / requiredFields).clamp(0.0, 1.0);
  }

  static TechnicalSheet updateState(TechnicalSheet sheet, {Map<String, dynamic>? serviceContext}) {
    final completeness = calculateCompleteness(sheet);
    final evaluation = serviceContext != null 
        ? CustomerDecisionEngine.evaluate(sheet, serviceContext)
        : sheet.systemState['last_evaluation'];

    return TechnicalSheet(
      schemaVersion: 2,
      userData: sheet.userData,
      systemState: <String, dynamic>{
        'completeness': completeness,
        'last_evaluation': evaluation,
        'risk_score': (evaluation?['decision'] == 'BLOCK') ? 100 : ((evaluation?['decision'] == 'WARN') ? 50 : 0),
      },
      legalState: sheet.legalState,
    );
  }
}
