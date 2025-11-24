import 'package:flutter/material.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();

  void _clearJournal() {
    if (_controller.text.isEmpty) return;

    // Mostrar diálogo de "Soltar"
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Liberar pensamiento?"),
        content: const Text("Al borrar esto, visualiza cómo el problema se aleja de tu mente."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              _controller.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✨ Pensamiento liberado ✨")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
            child: const Text("Liberar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text("Diario de Desahogo"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearJournal,
            tooltip: "Borrar todo",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Escribe lo que te preocupa. No lo guardaremos.",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null, // Multilínea infinita
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: "Hoy me siento...",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 18, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _clearJournal,
                icon: const Icon(Icons.cleaning_services),
                label: const Text("SOLTAR PENSAMIENTOS"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}