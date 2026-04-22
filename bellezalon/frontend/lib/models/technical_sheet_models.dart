import 'package:flutter/material.dart';

class AvatarPart {
  final String label;
  final String targetSection;
  final Rect relativeHitArea; // Coordenadas relativas 0.0 a 1.0 (x, y, width, height)
  final IconData icon;

  const AvatarPart({
    required this.label,
    required this.targetSection,
    required this.relativeHitArea,
    required this.icon,
  });
}

class TechnicalSheet {
  final int schemaVersion;
  final Map<String, dynamic> userData;
  final Map<String, dynamic> systemState;
  final Map<String, dynamic> legalState;

  TechnicalSheet({
    this.schemaVersion = 2,
    this.userData = const <String, dynamic>{
      'gender': 'Not Specified',
      'birth_date': '',
      'modules': <String, dynamic>{
        'morphology': <String, dynamic>{},
        'dermatology': <String, dynamic>{},
        'hair': <String, dynamic>{},
        'affections': [],
      },
      'evolution': [],
    },
    this.systemState = const <String, dynamic>{
      'completeness': 0.0,
      'last_evaluation': <String, dynamic>{'decision': 'PASS', 'timestamp': 0},
      'risk_score': 0,
    },
    this.legalState = const <String, dynamic>{
      'consent': <String, dynamic>{'accepted': false, 'timestamp': 0, 'version': '1.0'},
    },
  });

  factory TechnicalSheet.empty() => TechnicalSheet();

  static Map<String, dynamic> _safeMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static List<dynamic> _safeList(dynamic value) {
    if (value is List) return List<dynamic>.from(value);
    return <dynamic>[];
  }

  factory TechnicalSheet.fromJson(Map<String, dynamic> json) {
    if (json['schema_version'] == 1 || json['schema_version'] == null) {
      // Automatic migration to v2
      return TechnicalSheet(
        schemaVersion: 2,
        userData: <String, dynamic>{
          'gender': json['gender'] ?? 'Not Specified',
          'birth_date': json['birth_date'] ?? '',
          'modules': <String, dynamic>{
            'morphology': _safeMap(json['morphology']),
            'dermatology': _safeMap(json['dermatology']),
            'hair': _safeMap(json['hair']),
            'affections': [], // New in v2
          },
          'evolution': _safeList(json['evolution']),
        },
        systemState: {
          'completeness': 0.0,
          'last_evaluation': {'decision': 'PASS', 'timestamp': DateTime.now().millisecondsSinceEpoch},
          'risk_score': 0,
        },
        legalState: {
          'consent': {'accepted': true, 'timestamp': DateTime.now().millisecondsSinceEpoch, 'version': '1.0'},
        },
      );
    }

    return TechnicalSheet(
      schemaVersion: json['schema_version'] ?? 2,
      userData: _safeMap(json['user_data']),
      systemState: _safeMap(json['system_state']),
      legalState: _safeMap(json['legal_state']),
    );
  }

  Map<String, dynamic> toJson() => {
    'schema_version': schemaVersion,
    'user_data': userData,
    'system_state': systemState,
    'legal_state': legalState,
  };

  // Helper getters for backward compatibility and clean access
  Map<String, dynamic> get morphology => _getMapRef('morphology');
  Map<String, dynamic> get dermatology => _getMapRef('dermatology');
  Map<String, dynamic> get hair => _getMapRef('hair');
  
  List<dynamic> get evolution {
    if (userData['evolution'] is! List) userData['evolution'] = <dynamic>[];
    return userData['evolution'];
  }
  
  List<dynamic> get affections => _getListRef('affections');

  Map<String, dynamic> _getMapRef(String key) {
    var modules = userData['modules'];
    if (modules is! Map) {
      modules = <String, dynamic>{};
      userData['modules'] = modules;
    }
    if (modules[key] is! Map) {
      modules[key] = <String, dynamic>{};
    }
    return modules[key];
  }

  List<dynamic> _getListRef(String key) {
    var modules = userData['modules'];
    if (modules is! Map) {
      modules = <String, dynamic>{};
      userData['modules'] = modules;
    }
    if (modules[key] is! List) {
      modules[key] = <dynamic>[];
    }
    return modules[key];
  }
}

class EvolutionEvent {
  final String date;
  final String event;
  final String result;

  const EvolutionEvent({required this.date, required this.event, required this.result});

  Map<String, String> toJson() => {'date': date, 'event': event, 'result': result};
}
