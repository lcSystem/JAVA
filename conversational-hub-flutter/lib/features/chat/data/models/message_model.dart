import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.channelId,
    required super.senderId,
    required super.content,
    required super.type,
    super.metadata,
    required super.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      channelId: json['channelId'],
      senderId: json['senderId'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MessageType.text,
      ),
      metadata: json['metadata'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channelId': channelId,
      'senderId': senderId,
      'content': content,
      'type': type.toString().split('.').last,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
