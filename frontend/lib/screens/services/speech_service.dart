import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();

  bool _isInitialized = false;
  bool _isListening = false;

  Future<String?> startListening() async {
    // Inicializar solo una vez
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onError: (err) {
          // ignore: avoid_print
          print("Speech error: $err");
        },
        onStatus: (status) {
          // ignore: avoid_print
          print("Speech status: $status");
        },
      );
    }

    if (!_isInitialized) {
      // ignore: avoid_print
      print("❌ No se pudo inicializar Speech-to-Text");
      return null;
    }

    // Si ya está escuchando → detener para evitar error web
    if (_isListening) {
      await stopListening();
      return null;
    }

    _isListening = true;
    String text = "";

    await _speech.listen(
      localeId: "es_ES",
      // ignore: deprecated_member_use
      listenMode: ListenMode.dictation,
      onResult: (result) {
        text = result.recognizedWords;
      },
    );

    // Espera 4 segundos para capturar la voz
    await Future.delayed(const Duration(seconds: 4));

    // Detiene la escucha
    await stopListening();

    return text;
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    await _speech.stop();
    _isListening = false;
  }
}
