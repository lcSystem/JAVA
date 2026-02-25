import 'package:equatable/equatable.dart';

enum MessageType { text, card, system }

class Message extends Equatable {
  final String id;
  final String channelId;
  final String senderId;
  final String content;
  final MessageType type;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.channelId,
    required this.senderId,
    required this.content,
    required this.type,
    this.metadata,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, channelId, senderId, content, type, metadata, timestamp];
}
