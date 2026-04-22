class AvatarState {
  final String skinTone; // Hex color without #
  final String hair;     // hair style ID
  final String body;     // body/clothing ID
  final String eyes;     // eyes style ID
  final String mouth;    // mouth style ID
  final String nose;     // nose style ID
  final String facialHair;
  final List<String> conditions;
  final double completeness;

  AvatarState({
    this.skinTone = 'd6a57c',
    this.hair = 'shortCombover',
    this.body = 'rounded',
    this.eyes = 'open',
    this.mouth = 'smile',
    this.nose = 'mediumRound',
    this.facialHair = 'none',
    this.conditions = const [],
    this.completeness = 0.0,
  });

  AvatarState copyWith({
    String? skinTone,
    String? hair,
    String? body,
    String? eyes,
    String? mouth,
    String? nose,
    String? facialHair,
    List<String>? conditions,
    double? completeness,
  }) {
    return AvatarState(
      skinTone: skinTone ?? this.skinTone,
      hair: hair ?? this.hair,
      body: body ?? this.body,
      eyes: eyes ?? this.eyes,
      mouth: mouth ?? this.mouth,
      nose: nose ?? this.nose,
      facialHair: facialHair ?? this.facialHair,
      conditions: conditions ?? this.conditions,
      completeness: completeness ?? this.completeness,
    );
  }

  factory AvatarState.fromTechnicalSheet(Map<String, dynamic> morphology, Map<String, dynamic> systemState) {
    // Map old keys or use hex if present
    String tone = morphology['skin_tone_hex'] ?? morphology['skin_tone'];
    
    return AvatarState(
      skinTone: _isValidHex(tone) ? tone : _mapSkinTone(tone),
      hair: morphology['hair'] ?? 'shortCombover',
      body: morphology['body'] ?? 'rounded',
      eyes: morphology['eyes'] ?? 'open',
      mouth: morphology['mouth'] ?? 'smile',
      nose: morphology['nose'] ?? 'mediumRound',
      facialHair: morphology['facial_hair'] ?? 'none',
      conditions: List<String>.from(morphology['affections']?.map((e) => e['type'].toString()) ?? []),
      completeness: systemState['completeness'] ?? 0.0,
    );
  }

  static bool _isValidHex(String? s) {
    if (s == null) return false;
    final hexRegex = RegExp(r'^[0-9a-fA-F]{6}$');
    return hexRegex.hasMatch(s);
  }

  static String _mapSkinTone(String? tone) {
    switch (tone) {
      case 'muy_claro': return 'fde7d1';
      case 'claro': return 'fadcc0';
      case 'medio_claro': return 'ebc196';
      case 'medio': return 'd6a57c';
      case 'moreno_claro': return 'b98457';
      case 'moreno': return 'a26b40';
      case 'oscuro': return '7e4a2f';
      case 'muy_oscuro': return '4b2e1e';
      default: return 'd6a57c';
    }
  }

  String toDiceBearUrl() {
    String url = 'https://api.dicebear.com/7.x/personas/svg?'
        'skinColor=$skinTone&'
        'hair=$hair&'
        'body=$body&'
        'eyes=$eyes&'
        'mouth=$mouth&'
        'nose=$nose';
        
    if (facialHair != 'none' && facialHair.isNotEmpty) {
      url += '&facialHair=$facialHair';
    } else {
      url += '&facialHairProbability=0';
    }
    
    return url;
  }
}
