import 'package:flutter/material.dart';
import 'voice_controller.dart';

class VoiceButton extends StatefulWidget {
  final Function(String userText, String aiText) onMessageCompleted;

  const VoiceButton({required this.onMessageCompleted, super.key});

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  final VoiceController voice = VoiceController();
  String userSpeech = "";

  @override
  void initState() {
    super.initState();
    voice.initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: voice.isListening ? Colors.red : Colors.blue,
      child: Icon(voice.isListening ? Icons.mic : Icons.mic_none, size: 30),
      onPressed: () async {
        if (!voice.isListening) {
          // Start listening
          await voice.startListening((text) {
            setState(() {
              userSpeech = text;
            });
          });
        } else {
          // Stop listening
          await voice.stopListening();

          if (userSpeech.isNotEmpty) {
            final aiResponse = await voice.sendToAI(userSpeech);
            await voice.speak(aiResponse);

            widget.onMessageCompleted(userSpeech, aiResponse);
          }
        }
      },
    );
  }
}
