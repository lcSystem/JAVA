import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PresenceProvider with ChangeNotifier {
  final String baseUrl;
  final String token;
  List<dynamic> _users = [];

  PresenceProvider({required this.baseUrl, required this.token});

  List<dynamic> get users => _users;

  Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/chat/users'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _users = json.decode(response.body);
        notifyListeners();
        return _users;
      }
    } catch (e) {
      print('Error al obtener presencia: $e');
    }
    return _users;
  }
}
