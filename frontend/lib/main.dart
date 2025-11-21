import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/screens/historial_screen.dart'; // 🟩 Import del historial

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
      home: const AuthWrapper(), // 👈 control de sesión
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/chat': (context) => const ChatScreen(),
        '/historial': (context) => const HistorialScreen(), // 🟩 Nueva ruta
      },
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
