import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/avatar_state_model.dart';

class RealisticAvatarEngine extends StatelessWidget {
  final AvatarState state;
  final double size;

  const RealisticAvatarEngine({
    super.key, 
    required this.state, 
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Layer 1: The Human Core (DiceBear Engine)
            SvgPicture.network(
              state.toDiceBearUrl(),
              width: size,
              height: size,
              placeholderBuilder: (context) => const Center(
                child: SizedBox(
                   width: 20,
                   height: 20,
                   child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            
            // Layer 2: Optional Overlays (Salon Diagnostics / Health)
            if (state.conditions.isNotEmpty)
              ...state.conditions.map((c) => _buildConditionOverlay(c, size)),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionOverlay(String condition, double size) {
    // Positioning markers for specific conditions on the face
    double top = 0.4, left = 0.5;
    Color color = Colors.red.withOpacity(0.3);
    
    if (condition == 'alergy') { top = 0.3; left = 0.4; color = Colors.red.withOpacity(0.4); }
    if (condition == 'sensitivity') { top = 0.5; left = 0.6; color = Colors.orange.withOpacity(0.4); }

    return Positioned(
      top: size * top,
      left: size * left,
      child: Container(
        width: size * 0.1,
        height: size * 0.1,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.2), blurRadius: 4, spreadRadius: 2)
          ],
        ),
      ),
    );
  }
}
