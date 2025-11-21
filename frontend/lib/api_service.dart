import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://127.0.0.1:5001/asistant-ia/us-central1/chatWithAI';

  static Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['reply'] ?? 'No se recibió respuesta del asistente.';
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
