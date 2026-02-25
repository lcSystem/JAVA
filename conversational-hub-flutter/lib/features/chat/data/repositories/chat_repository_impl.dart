import 'dart:convert';
import 'package:conversational_hub_flutter/core/api_client.dart';
import 'package:conversational_hub_flutter/features/chat/domain/entities/channel.dart';
import 'package:conversational_hub_flutter/features/chat/domain/entities/message.dart';
import 'package:conversational_hub_flutter/features/chat/domain/repositories/chat_repository.dart';
import 'package:conversational_hub_flutter/features/chat/data/models/channel_model.dart';
import 'package:conversational_hub_flutter/features/chat/data/models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiClient apiClient;

  ChatRepositoryImpl({required this.apiClient});

  @override
  Future<List<Channel>> getChannels() async {
    final response = await apiClient.get('/api/chat/channels');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ChannelModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load channels');
  }

  @override
  Future<List<Message>> getMessages(String channelId) async {
    final response = await apiClient.get('/api/chat/channels/$channelId/messages');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load messages');
  }

  @override
  Future<void> sendMessage(String channelId, String content) async {
    final response = await apiClient.post('/api/chat/channels/$channelId/messages', {
      'content': content,
    });
    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
}
