import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/chat_screen.dart';

// 📌 Importar tu archivo de rutas
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase antes de correr la app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

      // 👇 Mantienes tu control de sesión EXACTO como lo tenías
      home: const AuthWrapper(),

      // 👇 Ruta centralizada en archivo aparte
      routes: AppRoutes.routes,
    );
  }
}

/// Esta clase decide si mostrar el login o el chat según el estado de autenticación
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:
          FirebaseAuth.instance
              .authStateChanges(), // escucha si hay cambios en sesión
      builder: (context, snapshot) {
        // Si Firebase aún está cargando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si el usuario está autenticado
        if (snapshot.hasData) {
          return const ChatScreen();
        }

        // Si no hay usuario logeado
        return const LoginScreen();
      },
    );
  }
}
