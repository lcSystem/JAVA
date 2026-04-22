import 'package:flutter/material.dart';
import '../models/technical_sheet_models.dart';

class SmartAvatar extends StatelessWidget {
  final Map<String, dynamic> morphology;
  final List<String> selectedZones;
  final Function(String) onPartTap;

  const SmartAvatar({
    super.key,
    required this.morphology,
    required this.selectedZones,
    required this.onPartTap,
  });

  @override
  Widget build(BuildContext context) {
    final skinColor = _getSkinColor(morphology['skin_tone']);
    
    // Relative Hitboxes (0-1 range) for Production-Grade Responsiveness
    const List<AvatarPart> parts = [
      AvatarPart(
        label: 'Cabello', 
        targetSection: 'hair', 
        relativeHitArea: Rect.fromLTWH(0.32, 0.02, 0.36, 0.22), 
        icon: Icons.face
      ),
      AvatarPart(
        label: 'Rostro', 
        targetSection: 'identity', 
        relativeHitArea: Rect.fromLTWH(0.40, 0.10, 0.20, 0.15), 
        icon: Icons.remove_red_eye
      ),
      AvatarPart(
        label: 'Cuerpo', 
        targetSection: 'dermatology', 
        relativeHitArea: Rect.fromLTWH(0.35, 0.28, 0.30, 0.35), 
        icon: Icons.accessibility
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: RepaintBoundary(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Layer 1: Base Contour
                Icon(Icons.person, size: height * 0.85, color: Colors.grey[100]),
                
                // Layer 2: Skin Tone Layer with Gradient
                _buildSkinLayer(skinColor, height),
                
                // Layer 3: Hair Visual Layer
                _buildHairLayer(morphology['hair_type'], height),
                
                // Layer 4: Interactive Indicators (Warning Markers)
                ...selectedZones.map((z) => _buildWarningIndicator(z, width, height)),

                // Layer 5: Responsive Interaction Motor (Hitboxes)
                ...parts.map((p) => Positioned(
                  top: p.relativeHitArea.top * height,
                  left: p.relativeHitArea.left * width,
                  width: p.relativeHitArea.width * width,
                  height: p.relativeHitArea.height * height,
                  child: GestureDetector(
                    onTap: () => onPartTap(p.targetSection),
                    behavior: HitTestBehavior.opaque,
                    child: Container(color: Colors.transparent),
                  ),
                )),
              ],
            ),
          ),
        );
      }
    );
  }

  Color _getSkinColor(String? tone) {
    switch (tone) {
      case 'muy_claro': return const Color(0xFFFFF3E0);
      case 'claro': return const Color(0xFFFBE9E7);
      case 'medio_claro': return const Color(0xFFFFCCBC);
      case 'medio': return const Color(0xFFD7CCC8);
      case 'moreno_claro': return const Color(0xFFBCAAA4);
      case 'moreno': return const Color(0xFFA1887F);
      case 'oscuro': return const Color(0xFF8D6E63);
      case 'muy_oscuro': return const Color(0xFF5D4037);
      default: return const Color(0xFFD7CCC8);
    }
  }

  Widget _buildHairLayer(String? type, double totalHeight) {
    IconData icon = Icons.blur_on;
    if (type == 'liso') icon = Icons.format_align_justify;
    if (type == 'ondulado') icon = Icons.waves;
    if (type == 'crespo') icon = Icons.filter_vintage;
    if (type == 'afro') icon = Icons.blur_circular;
    if (type == 'rapado') icon = Icons.hdr_strong;
    if (type == 'corto') icon = Icons.content_cut;
    
    return Positioned(
      top: totalHeight * 0.04,
      child: ShaderMask(
        shaderCallback: (Rect bounds) => RadialGradient(
          colors: [Colors.brown[900]!, Colors.brown[400]!],
          center: Alignment.center,
          radius: 0.6,
        ).createShader(bounds),
        child: Icon(icon, size: totalHeight * 0.26, color: Colors.white),
      ),
    );
  }

  Widget _buildSkinLayer(Color color, double totalHeight) {
    return Positioned(
      top: totalHeight * 0.28,
      child: ShaderMask(
        shaderCallback: (Rect bounds) => LinearGradient(
          colors: [color, color.withOpacity(0.4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds),
        child: Icon(Icons.accessibility_new, size: totalHeight * 0.48, color: color),
      ),
    );
  }

  Widget _buildWarningIndicator(String zoneId, double w, double h) {
    double top = 0.5, left = 0.5;
    if (zoneId == 'cabeza') { top = 0.1; left = 0.47; }
    if (zoneId == 'mano_izq') { top = 0.45; left = 0.25; }
    if (zoneId == 'mano_der') { top = 0.45; left = 0.68; }
    
    return Positioned(
      top: top * h,
      left: left * w,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 10),
      ),
    );
  }
}
