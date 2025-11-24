import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _tts = FlutterTts();

  TextToSpeechService() {
    _configureVoice();
  }

  Future<void> _configureVoice() async {
    await _tts.setLanguage("es-ES");

    // 💗 Voice preset estilo "chica anime kawaii"
    await _tts.setPitch(1.6);        // MUY agudito y cute
    await _tts.setSpeechRate(0.82);  // más lento = más tierno
    await _tts.setVolume(1.0);

    // intenta elegir voz femenina si existe
    List voices = await _tts.getVoices;
    for (var v in voices) {
      final name = v["name"].toString().toLowerCase();
      if (name.contains("female") || name.contains("woman") || name.contains("girl")) {
        await _tts.setVoice(v);
        break;
      }
    }
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
