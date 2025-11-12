// En: frontend/lib/screens/register_screen.dart
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // --- Controladores para leer el texto ---
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // --- Variables de estado ---
  String _errorMessage = '';
  bool _isLoading = false;

  // --- LÓGICA DE REGISTRO SIMULADA ---
  Future<void> _registerSimulado() async {
    // 1. Mostrar círculo de carga y limpiar errores
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // 2. Simular un retraso de red
    await Future.delayed(const Duration(seconds: 1));

    // 3. Validaciones
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, completa todos los campos.';
        _isLoading = false;
      });
      return; // Detiene la función
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Las contraseñas no coinciden.';
        _isLoading = false;
      });
      return; // Detiene la función
    }

    // --- Si todo está bien ---
    // Simulación exitosa
    // 4. Mostramos un diálogo de éxito y luego lo enviamos al Login

    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('¡Éxito!'),
            content: const Text(
              'Tu cuenta ha sido creada. Ahora puedes iniciar sesión.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // Cierra el diálogo
                  Navigator.of(context).pop(); // Regresa a la pantalla de login
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );

    // 5. Ocultar el círculo de carga
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Usamos 'SingleChildScrollView' para el teclado
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 2. Título
              const Text(
                'Crea tu Cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Completa los datos para registrarte',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),

              // 3. Campo de Texto para Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // 4. Campo de Texto para Contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 5. Campo de Texto para Confirmar Contraseña
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 6. Mensaje de Error (si lo hay)
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),

              // 7. Botón principal de "Registrarse"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Llama a la lógica simulada
                onPressed: _isLoading ? null : _registerSimulado,
                // Muestra el círculo de carga o el texto
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
                          'Crear Cuenta',
                          style: TextStyle(fontSize: 18),
                        ),
              ),
              const SizedBox(height: 20),

              // 8. Botón secundario para "Volver al Login"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes una cuenta?'),
                  TextButton(
                    onPressed: () {
                      // Cierra esta pantalla y vuelve a la anterior (Login)
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Inicia Sesión',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
