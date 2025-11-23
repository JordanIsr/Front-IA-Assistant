import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfessionalHelpScreen extends StatefulWidget {
  const ProfessionalHelpScreen({super.key});

  @override
  State<ProfessionalHelpScreen> createState() => _ProfessionalHelpScreenState();
}

class _ProfessionalHelpScreenState extends State<ProfessionalHelpScreen> {
  // 1. ⚙️ Función para construir el Drawer (Copiado para consistencia)
  Drawer _buildDrawer(BuildContext context) {
    // NOTA: El UserAuth debe obtenerse aquí también
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(currentUser?.email?.split("@")[0] ?? "Usuario"),
            accountEmail: Text(currentUser?.email ?? "Sin correo"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff42a5f5), Color(0xff1e88e5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_comment, color: Colors.green),
            title: const Text("Nuevo Chat"),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blueAccent),
            title: const Text("Inicio"),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.purple),
            title: const Text("Librería"),
            onTap: () => Navigator.pushReplacementNamed(context, '/library'),
          ),
          ListTile(
            leading: const Icon(Icons.toys_outlined, color: Colors.orange),
            title: const Text("Zona Anti-Estrés"),
            onTap:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/distraction-zone',
                ),
          ),
          ListTile(
            leading: const Icon(
              Icons.medical_services,
              color: Colors.redAccent,
            ),
            title: const Text("Recursos y Especialistas"),
            onTap: () => Navigator.pop(context), // Ya estamos aquí
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text("Configuración"),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Cerrar Sesión"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }

  // 2. 🏥 Widget para construir las tarjetas de recurso
  Widget _buildResourceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // 3. 🏗️ Estructura principal (Scaffold)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text(
          "Recursos y Especialistas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Container(
        // Mantenemos el mismo gradiente de fondo para consistencia
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3f2fd), Color(0xffbbdefb)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Busca apoyo profesional, inmediato o de largo plazo, cuando lo necesites.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color(0xff1e88e5),
                  ),
                ),
              ),

              // Tarjeta 1: Línea de Crisis
              _buildResourceCard(
                title: "Líneas de Crisis 🚨",
                subtitle: "Ayuda telefónica inmediata y anónima 24/7.",
                icon: Icons.phone_in_talk,
                color: Colors.red.shade700,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Navegando a Directorio de Líneas de Crisis...',
                      ),
                    ),
                  );
                  // Lógica de navegación: Navigator.pushNamed(context, '/crisis-lines');
                },
              ),

              // Tarjeta 2: Directorio de Terapeutas
              _buildResourceCard(
                title: "Encuentra un Especialista",
                subtitle: "Directorio de psicólogos, psiquiatras y consejeros.",
                icon: Icons.people_alt,
                color: Colors.indigo.shade600,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Navegando a Directorio de Especialistas...',
                      ),
                    ),
                  );
                  // Lógica de navegación: Navigator.pushNamed(context, '/therapist-directory');
                },
              ),

              // Tarjeta 3: Clínicas y Centros de Apoyo
              _buildResourceCard(
                title: "Clínicas y Centros Locales",
                subtitle:
                    "Opciones de atención presencial y hospitales cercanos.",
                icon: Icons.location_on,
                color: Colors.green.shade700,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Navegando a Centros de Apoyo Local...'),
                    ),
                  );
                  // Lógica de navegación: Navigator.pushNamed(context, '/local-centers');
                },
              ),

              // Tarjeta 4: Información de Salud Mental
              _buildResourceCard(
                title: "Información y Artículos",
                subtitle:
                    "Recursos educativos sobre condiciones y tratamientos.",
                icon: Icons.health_and_safety,
                color: Colors.purple.shade600,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Navegando a Recursos Informativos...'),
                    ),
                  );
                  // Lógica de navegación: Navigator.pushNamed(context, '/mental-health-info');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
