import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/openai_service.dart';

class VoiceController {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final OpenAIService _openAI = OpenAIService();

  bool isListening = false;
  String lastUserSpeech = "";

  Future<bool> initSpeech() async {
    return await _speech.initialize();
  }

  Future<void> startListening(Function(String) onResult) async {
    await _speech.listen(
      onResult: (result) {
        lastUserSpeech = result.recognizedWords;
        onResult(lastUserSpeech);
      },
    );

    isListening = true;
  }

  Future<void> stopListening() async {
    await _speech.stop();
    isListening = false;
  }

  Future<void> speak(String text) async {
    await _tts.setLanguage("es-ES");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.9);
    await _tts.speak(text);
  }

  Future<String> sendToAI(String text) async {
    return await _openAI.sendMessage(text);
  }
}
