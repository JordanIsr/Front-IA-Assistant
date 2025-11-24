// Archivo: lib/screens/topic_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TopicDetailScreen extends StatelessWidget {
  const TopicDetailScreen({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 AQUÍ RECIBIMOS LOS DATOS DE LA RUTA
    final topic = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final color = topic['color'] as Color;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // CABECERA CON IMAGEN GRANDE
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                topic['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                ),
              ),
              background: Image.network(
                topic['image'],
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: color),
              ),
            ),
          ),

          // CONTENIDO
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono y Descripción
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(topic['icon'], color: color, size: 30),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          topic['shortDescription'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    topic['longDescription'],
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                  
                  const SizedBox(height: 30),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 20),

                  // PASOS
                  Text("💡 Pasos recomendados", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 15),
                  ... (topic['steps'] as List).map((step) => _buildStepCard(step, color)),

                  const SizedBox(height: 30),

                  // RECURSOS
                  Text("🔗 Recursos útiles", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: (topic['links'] as List).map((link) {
                      return ActionChip(
                        avatar: const Icon(Icons.play_circle_fill, color: Colors.white),
                        label: Text(link['title'], style: const TextStyle(color: Colors.white)),
                        backgroundColor: color,
                        onPressed: () => _launchURL(link['url']),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(Map<String, dynamic> step, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text(step['body'], style: TextStyle(color: Colors.grey[700], fontSize: 14)),
        ],
      ),
    );
  }
}