import 'package:flutter/material.dart';
// Imports de tus pantallas
import 'package:frontend/screens/games/bubble_pop_screen.dart'; 
import 'package:frontend/screens/distraction/breathing_screen.dart';
import 'package:frontend/screens/distraction/sounds_screen.dart';    
import 'package:frontend/screens/distraction/journal_screen.dart';

class ActivityDetailScreen extends StatelessWidget {
  const ActivityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activity = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Color color = activity['color'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(activity['title']),
        backgroundColor: color,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabecera grande con el icono
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Icon(activity['icon'], size: 100, color: Colors.white.withValues(alpha: 0.9)),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "¿En qué consiste?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    activity['description'],
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Text(
                    "Instrucciones:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 15),
                  
                  // Lista de instrucciones sin el .toList() innecesario
                  ... (activity['instructions'] as List).map((inst) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline, color: color, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(inst, style: const TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  )), 

                  const SizedBox(height: 40),

                  // BOTÓN CON LA LÓGICA COMPLETA
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Obtenemos el ID para saber a dónde ir
                        final String id = activity['id'];

                        if (id == 'games') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BubblePopScreen()),
                          );
                        } else if (id == 'breathing') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BreathingScreen()),
                          );
                        } else if (id == 'sounds') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SoundsScreen()),
                          );
                        } else if (id == 'journal') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const JournalScreen()),
                          );
                        } else {
                          // Por si agregas algo nuevo y olvidas crear la pantalla
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Iniciando ${activity['title']}... (Próximamente)'),
                              backgroundColor: color,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      icon: const Icon(Icons.play_circle_filled, size: 28, color: Colors.white),
                      label: const Text(
                        "COMENZAR AHORA",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}