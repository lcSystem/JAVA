import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    bool isSticker = message.content.startsWith('[STICKER]:');
    String displayContent = isSticker ? message.content.substring(10) : message.content;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.primaries[message.senderId.hashCode % Colors.primaries.length].withOpacity(0.2),
                  child: Text(
                    message.senderId.isNotEmpty ? message.senderId[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.primaries[message.senderId.hashCode % Colors.primaries.length],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                message.senderId, 
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white70)
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('HH:mm').format(message.timestamp), 
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (isSticker)
            Container(
              margin: EdgeInsets.only(left: isMe ? 0 : 32, right: isMe ? 32 : 0),
              child: Text(
                displayContent,
                style: const TextStyle(fontSize: 64),
              ),
            )
          else
            Container(
              margin: EdgeInsets.only(left: isMe ? 0 : 32, right: isMe ? 0 : 0),
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
              decoration: BoxDecoration(
                gradient: isMe 
                    ? const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF2D55)])
                    : null,
                color: isMe ? null : const Color(0xFF2C2C3E),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  )
                ]
              ),
              child: Text(
                displayContent,
                style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.3),
              ),
            ),
        ],
      ),
    );
  }
}
