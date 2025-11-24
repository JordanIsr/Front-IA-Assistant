import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with TickerProviderStateMixin {
  // Estado de la animación
  String _instruction = "Prepárate...";
  double _size = 150.0; // Tamaño inicial del círculo
  Color _color = Colors.blue.shade200;
  bool _isActive = false;

  @override
  void dispose() {
    _isActive = false; // Detener bucle al salir
    super.dispose();
  }

  void _startBreathing() async {
    setState(() {
      _isActive = true;
    });

    while (_isActive) {
      if (!mounted) break;

      // 1. INHALAR (4 segundos)
      setState(() {
        _instruction = "Inhala (Nariz)";
        _size = 300.0; // Crece
        _color = Colors.blue.shade400;
      });
      HapticFeedback.lightImpact();
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted || !_isActive) break;

      // 2. RETENER (7 segundos)
      setState(() {
        _instruction = "Retén el aire";
        _size = 320.0; // Se mantiene grande (pulsa un poco)
        _color = Colors.purple.shade300;
      });
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(seconds: 7));
      if (!mounted || !_isActive) break;

      // 3. EXHALAR (8 segundos)
      setState(() {
        _instruction = "Exhala (Boca)";
        _size = 150.0; // Se encoge
        _color = Colors.green.shade300;
      });
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(seconds: 8));
    }
  }

  void _stopBreathing() {
    setState(() {
      _isActive = false;
      _instruction = "Listo. ¿Mejor?";
      _size = 150.0;
      _color = Colors.blue.shade200;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Respiración 4-7-8"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _instruction,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
              ),
            ),
            const SizedBox(height: 50),
            
            // EL CÍRCULO ANIMADO
            AnimatedContainer(
              duration: Duration(seconds: _instruction.contains("Inhala") ? 4 : _instruction.contains("Exhala") ? 8 : 1),
              curve: Curves.easeInOut,
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _color,
                boxShadow: [
                  BoxShadow(
                    color: _color.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: Center(
                child: _isActive 
                  ? null 
                  : Icon(Icons.play_arrow_rounded, size: 60, color: Colors.white.withOpacity(0.8)),
              ),
            ),
            
            const SizedBox(height: 60),

            if (!_isActive)
              ElevatedButton.icon(
                onPressed: _startBreathing,
                icon: const Icon(Icons.play_circle),
                label: const Text("Iniciar Ejercicio"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: _stopBreathing,
                icon: const Icon(Icons.stop_circle),
                label: const Text("Detener"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
          ],
        ),
      ),
    );
  }
}