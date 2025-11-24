import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importación necesaria para la librería de PDF (ELIMINADA de aquí, solo se usa en book_viewer_screen.dart).
import 'package:frontend/screens/distraction_zone_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/library_screen.dart';
import 'package:frontend/screens/professional_help_screen.dart';
import 'firebase_options.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/screens/historial_screen.dart';
// IMPLEMENTACIÓN REQUERIDA: Importar la nueva pantalla del visor de libros
import 'package:frontend/screens/book_viewer_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOTA: Si usas la versión de prueba, puedes comentar la línea
  // de registro de licencia. Si el PDF sigue sin verse, debes obtener
  // la clave de licencia gratuita en la web de Syncfusion y ponerla aquí.
  // SyncfusionLicense.registerLicense('TU_CLAVE_DE_LICENCIA_AQUI');

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
        '/historial': (context) => const HistorialScreen(),
        '/home': (context) => const HomeScreen(),
        '/library': (context) => const LibraryScreen(),
        '/distraction-zone': (context) => const DistractionZoneScreen(),
        '/professional-help': (context) => const ProfessionalHelpScreen(),
        // IMPLEMENTACIÓN REQUERIDA: Agregar la ruta del visor de libros
        '/book-viewer': (context) => const BookViewerScreen(),
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
