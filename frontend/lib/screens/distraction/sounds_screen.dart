import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundsScreen extends StatefulWidget {
  const SoundsScreen({super.key});

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  final AudioPlayer _player = AudioPlayer();
  String? _playingId; // Para saber cuál está sonando

  // Lista de sonidos (URLs de prueba)
  final List<Map<String, dynamic>> sounds = [
    {'id': 'rain', 'name': 'Lluvia Suave', 'icon': Icons.water_drop, 'color': Colors.blue, 'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'}, // Reemplaza con URL real de lluvia
    {'id': 'forest', 'name': 'Bosque', 'icon': Icons.forest, 'color': Colors.green, 'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'},
    {'id': 'fire', 'name': 'Fuego', 'icon': Icons.local_fire_department, 'color': Colors.orange, 'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'},
    {'id': 'white', 'name': 'Ruido Blanco', 'icon': Icons.radio, 'color': Colors.grey, 'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3'},
  ];

  @override
  void dispose() {
    _player.dispose(); // Detener audio al salir
    super.dispose();
  }

  Future<void> _toggleSound(String id, String url) async {
    if (_playingId == id) {
      await _player.stop();
      setState(() => _playingId = null);
    } else {
      await _player.stop(); // Detener el anterior
      await _player.setReleaseMode(ReleaseMode.loop); // Repetir en bucle
      await _player.play(UrlSource(url));
      setState(() => _playingId = id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("Sonidos Relajantes"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: sounds.length,
        itemBuilder: (context, index) {
          final s = sounds[index];
          final isPlaying = _playingId == s['id'];

          return GestureDetector(
            onTap: () => _toggleSound(s['id'], s['url']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isPlaying ? s['color'] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (s['color'] as Color).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
                border: isPlaying ? Border.all(color: Colors.white, width: 3) : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPlaying ? Icons.pause_circle_filled : s['icon'],
                    size: 50,
                    color: isPlaying ? Colors.white : s['color'],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    s['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isPlaying ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (isPlaying) ...[
                    const SizedBox(height: 5),
                    const Text("Reproduciendo...", style: TextStyle(color: Colors.white70, fontSize: 12))
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}