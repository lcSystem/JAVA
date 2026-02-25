import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:conversational_hub_flutter/core/websocket_client.dart';
import 'package:conversational_hub_flutter/features/chat/domain/entities/channel.dart';
import 'package:conversational_hub_flutter/features/chat/domain/entities/message.dart';
import 'package:conversational_hub_flutter/features/chat/domain/repositories/chat_repository.dart';
import 'package:conversational_hub_flutter/features/chat/data/models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository repository;
  final WebSocketClient wsClient;

  List<Channel> _channels = [];
  List<Message> _messages = [];
  Channel? _selectedChannel;
  bool _isLoading = false;

  List<Channel> get channels => _channels;
  List<Message> get messages => _messages;
  Channel? get selectedChannel => _selectedChannel;
  bool get isLoading => _isLoading;

  ChatProvider({required this.repository, required this.wsClient}) {
    _initWebSocket();
  }

  void _initWebSocket() {
    wsClient.connect();
    wsClient.stream?.listen((data) {
      final event = jsonDecode(data);
      if (event['type'] == 'message') {
        final newMessage = MessageModel.fromJson(event['data']);
        if (newMessage.channelId == _selectedChannel?.id) {
          _messages.add(newMessage);
          notifyListeners();
        }
      }
    });
  }

  Future<void> loadChannels() async {
    _isLoading = true;
    notifyListeners();
    try {
      _channels = await repository.getChannels();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectChannel(Channel channel) async {
    _selectedChannel = channel;
    _messages = [];
    notifyListeners();
    
    _isLoading = true;
    notifyListeners();
    try {
      _messages = await repository.getMessages(channel.id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String content) async {
    if (_selectedChannel == null) return;
    await repository.sendMessage(_selectedChannel!.id, content);
  }

  @override
  void dispose() {
    wsClient.disconnect();
    super.dispose();
  }
}
