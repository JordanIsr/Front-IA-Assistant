import 'package:flutter/material.dart';

class RecordOverlay extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSend;

  const RecordOverlay({
    super.key,
    required this.onCancel,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mic, size: 60, color: Colors.red),
              const SizedBox(height: 10),
              const Text(
                "Grabando...",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    onPressed: onCancel,
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text("Cancelar"),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: onSend,
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text("Enviar"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
