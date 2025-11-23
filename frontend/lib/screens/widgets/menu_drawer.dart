import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              Navigator.pushReplacementNamed(context, '/chat');
            },
          ),

          ListTile(
            leading: const Icon(Icons.history, color: Colors.blueAccent),
            title: const Text("Historial del Chat"),
            onTap: () => Navigator.pushNamed(context, '/historial'),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.home, color: Colors.blueAccent),
            title: const Text("Inicio"),
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),

          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.purple),
            title: const Text("Librería"),
            onTap: () => Navigator.pushNamed(context, '/library'),
          ),

          ListTile(
            leading: const Icon(Icons.toys_outlined, color: Colors.orange),
            title: const Text("Zona Anti-Estrés"),
            onTap: () => Navigator.pushNamed(context, '/distraction-zone'),
          ),

          ListTile(
            leading: const Icon(Icons.medical_services, color: Colors.redAccent),
            title: const Text("Recursos y Especialistas"),
            onTap: () => Navigator.pushNamed(context, '/professional-help'),
          ),

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
}
