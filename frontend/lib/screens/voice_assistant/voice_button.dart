import 'package:flutter/material.dart';
import '../widgets/record_overlay.dart';
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
  bool showOverlay = false;

  @override
  void initState() {
    super.initState();
    voice.initSpeech();
  }

  Future<void> sendMessage() async {
    final aiResponse = await voice.sendToAI(userSpeech);
    await voice.speak(aiResponse);
    widget.onMessageCompleted(userSpeech, aiResponse);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // BOTÓN PRINCIPAL (tocar una vez para hablar)
        FloatingActionButton(
          backgroundColor: voice.isListening ? Colors.red : Colors.blue,
          child: Icon(
            voice.isListening ? Icons.mic : Icons.mic_none,
            size: 30,
          ),
          onPressed: () async {
            if (!voice.isListening) {
              setState(() {
                showOverlay = true; // Mostrar UI tipo WhatsApp
              });

              await voice.startListening((text) {
                setState(() {
                  userSpeech = text;
                });
              }, onFinal: () async {
                // Cuando detecta silencio → se terminó
                setState(() => showOverlay = false);

                if (userSpeech.isNotEmpty) {
                  await sendMessage();
                }
              });
            }
          },
        ),

        // OVERLAY FLOTANTE TIPO WHATSAPP
        if (showOverlay)
          RecordOverlay(
            onCancel: () async {
              await voice.stopListening();
              setState(() {
                showOverlay = false;
                userSpeech = "";
              });
            },
            onSend: () async {
              await voice.stopListening();
              setState(() => showOverlay = false);

              if (userSpeech.isNotEmpty) {
                await sendMessage();
              }
            },
          ),
      ],
    );
  }
}
