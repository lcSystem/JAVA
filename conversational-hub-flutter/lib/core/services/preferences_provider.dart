import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PreferencesProvider with ChangeNotifier {
  final String baseUrl;
  final String token;

  bool _isFloatingBubble = false;
  Color _primaryColor = Colors.indigo;
  Color _accentColor = Colors.orangeAccent;
  bool _isDarkMode = false;
  String _appName = 'Hub';
  String _userStatus = 'Disponible';

  PreferencesProvider({required this.baseUrl, required this.token});

  bool get isFloatingBubble => _isFloatingBubble;
  Color get primaryColor => _primaryColor;
  Color get accentColor => _accentColor;
  bool get isDarkMode => _isDarkMode;
  String get appName => _appName;
  String get userStatus => _userStatus;

  Future<void> loadPreferences() async {
    await loadGlobalDesign(); // Cargar diseño primero
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/chat/preferences'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _isFloatingBubble = data['isFloatingBubble'] ?? false;
        _userStatus = data['userStatus'] ?? 'Disponible';
        notifyListeners();
      }
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  Future<void> loadGlobalDesign() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/design'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _primaryColor = _hexToColor(data['primaryColor'] ?? '#3F51B5');
        _accentColor = _hexToColor(data['accentColor'] ?? '#FFAB40');
        _isDarkMode = data['isDarkMode'] ?? false;
        _appName = data['appName'] ?? 'Conversational Hub';
        notifyListeners();
      }
    } catch (e) {
      print('Error loading global design: $e');
    }
  }

  Future<void> updatePreferences({bool? isFloatingBubble, String? userStatus}) async {
    if (isFloatingBubble != null) _isFloatingBubble = isFloatingBubble;
    if (userStatus != null) _userStatus = userStatus;
    notifyListeners();

    try {
      await http.post(
        Uri.parse('$baseUrl/api/chat/preferences'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'isFloatingBubble': _isFloatingBubble,
          'userStatus': _userStatus,
        }),
      );
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }

  Color _hexToColor(String hexString) {
    if (hexString.isEmpty) return Colors.indigo;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
