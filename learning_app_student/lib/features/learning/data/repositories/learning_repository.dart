import 'dart:convert';
import 'package:http/http.dart' as http;

class LearningRepository {
  final String baseUrl = "http://localhost:8080/api/v1";

  Future<List<Map<String, dynamic>>> getSubjects() async {
    final response = await http.get(Uri.parse("$baseUrl/learning/subjects"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    return [];
  }

  Future<bool> createSubject(String name, String description) async {
    final response = await http.post(
      Uri.parse("$baseUrl/learning/subjects"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"name": name, "description": description}),
    );
    return response.statusCode == 201;
  }
}
