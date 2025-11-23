import 'package:flutter/material.dart';

// Importación de pantallas
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/screens/historial_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/library_screen.dart';
import 'package:frontend/screens/distraction_zone_screen.dart';
import 'package:frontend/screens/professional_help_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/chat': (context) => const ChatScreen(),
    '/historial': (context) => const HistorialScreen(),
    '/home': (context) => const HomeScreen(),
    '/library': (context) => const LibraryScreen(),
    '/distraction-zone': (context) => const DistractionZoneScreen(),
    '/professional-help': (context) => const ProfessionalHelpScreen(),
  };
}
