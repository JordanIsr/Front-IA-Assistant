import 'package:flutter/material.dart';
// 1. IMPORTAMOS TUS COMPONENTES Y DATOS
import 'package:frontend/screens/widgets/menu_drawer.dart'; 
import 'package:frontend/data/distraction_data.dart';

class DistractionZoneScreen extends StatefulWidget {
  const DistractionZoneScreen({super.key});

  @override
  State<DistractionZoneScreen> createState() => _DistractionZoneScreenState();
}

class _DistractionZoneScreenState extends State<DistractionZoneScreen> {
  
  // Widget para construir las tarjetas (optimizado)
  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // 🚀 NAVEGACIÓN: Vamos al detalle pasando los datos
          Navigator.pushNamed(
            context, 
            '/activity-detail',
            arguments: activity
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (activity['color'] as Color).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(activity['icon'], size: 30, color: activity['color']),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: activity['color'],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity['subtitle'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🚀 USAMOS EL DRAWER REUTILIZABLE (Mucho más limpio)
      drawer: const MenuDrawer(), 
      appBar: AppBar(
        title: const Text(
          "Zona Anti-Estrés",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3f2fd), Color(0xffbbdefb)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Tómate un descanso.\nElige una actividad para calmarte o distraerte.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color(0xff1565c0),
                  ),
                ),
              ),
              
              // 🚀 LISTA GENERADA AUTOMÁTICAMENTE DESDE LOS DATOS
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: distractionActivities.length,
                  itemBuilder: (context, index) {
                    return _buildActivityCard(distractionActivities[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}