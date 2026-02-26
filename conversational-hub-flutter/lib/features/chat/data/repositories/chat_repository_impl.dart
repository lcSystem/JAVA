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

  @override
  Future<Channel> getOrCreatePrivateChannel(String otherUserId, String otherUsername) async {
    final response = await apiClient.get('/api/chat/channels');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final channels = data.map((json) => ChannelModel.fromJson(json)).toList();
      
      try {
        return channels.firstWhere(
          (c) => c.erpEntityType == 'user' && c.erpEntityId == otherUserId,
        );
      } catch (_) {
        // Create new
        final createResponse = await apiClient.post('/api/chat/channels', {
          'name': 'Chat con $otherUsername',
          'description': 'Canal privado',
          'erpEntityType': 'user',
          'erpEntityId': otherUserId,
        });

        if (createResponse.statusCode == 201) {
          return ChannelModel.fromJson(jsonDecode(createResponse.body));
        }
      }
    }
    throw Exception('Failed to manage private channel');
  }
}
