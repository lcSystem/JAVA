import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conversational_hub_flutter/core/api_client.dart';
import 'package:conversational_hub_flutter/core/websocket_client.dart';
import 'package:conversational_hub_flutter/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:conversational_hub_flutter/features/chat/presentation/providers/chat_provider.dart';
import 'package:conversational_hub_flutter/features/chat/presentation/pages/chat_page.dart';

void main() {
  final apiClient = ApiClient(baseUrl: 'http://localhost:8080'); // Adjust to real backend URL
  final wsClient = WebSocketClient(url: 'ws://localhost:8080/ws');
  final chatRepository = ChatRepositoryImpl(apiClient: apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatProvider(
            repository: chatRepository,
            wsClient: wsClient,
          ),
        ),
      ],
      child: const ConversationalHubApp(),
    ),
  );
}

class ConversationalHubApp extends StatelessWidget {
  const ConversationalHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP Conversational Hub',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const ChatPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
