import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  // AQUÍ PEGAS LA URL QUE TE DIO LA TERMINAL
  final String backendUrl = 'https://us-central1-asistant-ia.cloudfunctions.net/chatWithAI'; 

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "message": message, 
          "userId": "usuario_flutter_app" // Opcional: Aquí podrías mandar el ID real
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Tu backend devuelve: { "reply": "Respuesta de la IA..." }
        return data['reply']; 
      } else {
        return "Error del servidor (${response.statusCode}): ${response.body}";
      }
    } catch (e) {
      return "Error de conexión: $e";
    }
  }
}