import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conversational_hub_flutter/core/api_client.dart';
import 'package:conversational_hub_flutter/core/websocket_client.dart';
import 'package:conversational_hub_flutter/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:conversational_hub_flutter/features/chat/presentation/providers/chat_provider.dart';
import 'package:conversational_hub_flutter/features/chat/presentation/pages/chat_page.dart';
import 'package:conversational_hub_flutter/features/config/presentation/pages/config_page.dart';
import 'package:conversational_hub_flutter/ui/screens/user_list_screen.dart';
import 'package:conversational_hub_flutter/core/services/preferences_provider.dart';
import 'package:conversational_hub_flutter/core/services/presence_provider.dart';

void main() {
  // Leer configuración inyectada por el host (Next.js)
  final String token = html.window.localStorage['jwtToken'] ?? 'mock-token';
  const String baseUrl = 'http://localhost:8080';
  const String wsUrl = 'ws://localhost:8080/ws';

  final apiClient = ApiClient(baseUrl: baseUrl);
  final wsClient = WebSocketClient(url: wsUrl);
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
        ChangeNotifierProvider(
          create: (_) => PresenceProvider(
            baseUrl: baseUrl,
            token: token,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            baseUrl: baseUrl,
            token: token,
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
      initialRoute: '/',
      routes: {
        '/': (context) => const ChatPage(),
        '/config': (context) => const ConfigPage(),
        '/users': (context) => UserListScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
