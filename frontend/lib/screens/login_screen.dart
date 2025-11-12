// En: frontend/lib/screens/login_screen.dart
import 'package:flutter/material.dart';

// Importamos el paquete de íconos que ya agregamos
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // --- Controladores para leer el texto ---
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // --- Variables de estado ---
  String _errorMessage = ''; // Para mostrar errores
  bool _isLoading = false; // Para mostrar un círculo de carga

  // --- LÓGICA DE LOGIN SIMULADA ---
  Future<void> _loginSimulado() async {
    // 1. Mostrar círculo de carga y limpiar errores
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // 2. Simular un retraso de red (como si estuviera verificando)
    await Future.delayed(const Duration(seconds: 2));

    // 3. Define aquí tu usuario "falso"
    const String emailCorrecto = 'user@test.com';
    const String passCorrecto = 'password123';

    // 4. Verifica las credenciales
    if (_emailController.text == emailCorrecto &&
        _passwordController.text == passCorrecto) {
      // Éxito: Navega al chat
      // Usamos 'mounted' para asegurarnos que el widget todavía existe
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/chat');
    } else {
      // Error: Muestra un mensaje
      setState(() {
        _errorMessage = 'Usuario o contraseña incorrectos.';
      });
    }

    // 5. Ocultar el círculo de carga
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              const Text(
                'Bienvenido',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Inicia sesión en tu cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Campos de Email y Contraseña
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo (user@test.com)', // Pista para probar
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña (password123)', // Pista para probar
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Mensaje de Error (si lo hay)
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 12),

              // Botón de "Ingresar"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // 6. Llama a la lógica simulada y deshabilita si está cargando
                onPressed: _isLoading ? null : _loginSimulado,

                // 7. Muestra el círculo de carga o el texto
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                        : const Text(
                          'Ingresar',
                          style: TextStyle(fontSize: 18),
                        ),
              ),
              const SizedBox(height: 20),

              // Separador "o"
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'o',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // Botones Sociales (sin lógica por ahora)
              OutlinedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                label: const Text('Continuar con Google'),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const FaIcon(
                  FontAwesomeIcons.facebook,
                  color: Colors.blue,
                ),
                label: const Text('Continuar con Facebook'),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Link a Registrarse
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Nuevo en Personal Assistant?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Crear una cuenta'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
