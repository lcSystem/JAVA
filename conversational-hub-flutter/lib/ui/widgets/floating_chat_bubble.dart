import 'package:flutter/material.dart';

class FloatingChatBubble extends StatefulWidget {
  final VoidCallback onTap;
  final bool isVisible;
  final Color themeColor;

  const FloatingChatBubble({
    super.key, 
    required this.onTap, 
    this.isVisible = true,
    this.themeColor = Colors.blueAccent,
  });

  @override
  State<FloatingChatBubble> createState() => _FloatingChatBubbleState();
}

class _FloatingChatBubbleState extends State<FloatingChatBubble> {
  Offset position = const Offset(20, 100);

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: _buildBubble(opacity: 0.5),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          setState(() {
            position = details.offset;
          });
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: _buildBubble(),
        ),
      ),
    );
  }

  Widget _buildBubble({double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Material(
        elevation: 8,
        shape: const CircleBorder(),
        color: widget.themeColor,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [widget.themeColor, widget.themeColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.chat_bubble, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
