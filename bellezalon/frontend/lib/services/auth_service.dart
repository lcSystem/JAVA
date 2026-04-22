import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = ApiService.baseUrl;

  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['jwt'];
    }
    return null;
  }
}
