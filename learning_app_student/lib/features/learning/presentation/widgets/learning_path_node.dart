import 'package:flutter/material.dart';

class LearningPathNode extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback onTap;

  const LearningPathNode({
    Key? key,
    required this.title,
    this.isCompleted = false,
    this.isLocked = true,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Duolingo colors
    const Color activeColor = Color(0xFF58CC02);
    const Color activeShadow = Color(0xFF46A302);
    const Color lockedColor = Color(0xFFE5E5E5);
    const Color lockedShadow = Color(0xFFAFAFAF);

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // 3D Shadow effect
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isLocked ? lockedShadow : activeShadow,
                  shape: BoxShape.circle,
                ),
              ),
              // Main circle
              Positioned(
                top: 0,
                child: Container(
                  width: 90,
                  height: 82,
                  decoration: BoxDecoration(
                    color: isLocked ? lockedColor : (isCompleted ? activeColor : const Color(0xFF1CB0F6)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isLocked ? Icons.lock : (isCompleted ? Icons.check : Icons.play_arrow),
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: isLocked ? const Color(0xFFAFAFAF) : const Color(0xFF3C3C3C),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
