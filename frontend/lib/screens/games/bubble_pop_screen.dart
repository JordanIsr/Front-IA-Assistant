import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para la vibración (Haptics)

class BubblePopScreen extends StatefulWidget {
  const BubblePopScreen({super.key});

  @override
  State<BubblePopScreen> createState() => _BubblePopScreenState();
}

class _BubblePopScreenState extends State<BubblePopScreen> {
  // Generamos 30 burbujas iniciales
  List<bool> bubbles = List.generate(30, (index) => false);

  void _popBubble(int index) {
    if (bubbles[index] == false) {
      setState(() {
        bubbles[index] = true;
      });
      // Vibración ligera para simular el "pop" táctil
      HapticFeedback.mediumImpact();
      
      // (Opcional) Aquí podrías poner un sonido de "pop" si tuvieras el archivo
    }
  }

  void _resetGame() {
    setState(() {
      bubbles = List.generate(30, (index) => false);
    });
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("Explotar Burbujas", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Reiniciar Plástico',
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "¡Toca para explotar!",
                style: TextStyle(fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // LA GRILLA DE BURBUJAS
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))
                    ],
                  ),
                  child: GridView.builder(
                    itemCount: bubbles.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 4 burbujas por fila
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _popBubble(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bubbles[index] 
                                ? Colors.orange.withOpacity(0.1) // Explotada (transparente)
                                : Colors.orange,                 // Intacta (color fuerte)
                            boxShadow: bubbles[index]
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.orange.shade700,
                                      offset: const Offset(2, 4), // Sombra 3D
                                      blurRadius: 1,
                                    )
                                  ],
                            border: Border.all(color: Colors.orange.shade800, width: 2),
                          ),
                          child: bubbles[index]
                              ? const Icon(Icons.check, color: Colors.orange, size: 20)
                              : Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Colors.white54, Colors.transparent],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _resetGame,
                icon: const Icon(Icons.refresh),
                label: const Text("Burbujas Nuevas"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}