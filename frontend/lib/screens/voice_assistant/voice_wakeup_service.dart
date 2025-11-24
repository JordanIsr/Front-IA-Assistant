import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';

class KeywordSpeechService {
  final SpeechToText _speech = SpeechToText();

  bool isActivated = false;
  String collectedSpeech = "";
  Timer? _silenceTimer;

  /// Callback externo cuando Leslie detecta la frase completa
  Function(String message)? onMessageReady;

  Future<void> init() async {
    await _speech.initialize();
    _startKeywordListener();
  }

  /// 🔵 Escucha SIEMPRE buscando la palabra clave "leslie"
  void _startKeywordListener() async {
    await _speech.listen(
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
      ),
      onResult: (result) {
        final text = result.recognizedWords.toLowerCase();

        if (text.contains("leslie")) {
          isActivated = true;
          collectedSpeech = "";

          _speech.stop();

          // pequeña pausa para reiniciar audio
          Future.delayed(
              const Duration(milliseconds: 300), _startFullListening);
        }
      },
    );
  }

  /// 🔴 Escucha lo que el usuario quiere decir después de "Leslie"
  void _startFullListening() async {
    await _speech.listen(
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
      ),
      onResult: (result) {
        collectedSpeech = result.recognizedWords;

        // reinicia detector de silencio
        _silenceTimer?.cancel();
        _silenceTimer = Timer(const Duration(seconds: 4), () {
          _stopAndSend();
        });
      },
    );
  }

  /// 🚀 Finaliza y envía el mensaje a la IA
  Future<void> _stopAndSend() async {
    await _speech.stop();

    if (collectedSpeech.trim().isNotEmpty) {
      onMessageReady?.call(collectedSpeech.trim());
    }

    // reiniciar todo
    isActivated = false;
    collectedSpeech = "";

    _startKeywordListener();
  }

  /// 🛑 Se llama desde dispose()
  Future<void> stop() async {
    _silenceTimer?.cancel();
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
}
