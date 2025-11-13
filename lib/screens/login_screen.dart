// Importar Flutter (para widgets) y Firebase Auth (para login)
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- Pantalla de Inicio de Sesión / Registro ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para leer el texto que el usuario escribe
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable para guardar mensajes de error y mostrarlos
  String _errorMessage = '';

  // --- Lógica de Registro ---
  Future<void> _handleRegister() async {
    try {
      // Limpia errores anteriores
      if (mounted) setState(() { _errorMessage = ''; });

      // Usamos los controladores para tomar el email y la pass
      final email = _emailController.text;
      final password = _passwordController.text;

      // Le pedimos a Firebase Auth que cree un nuevo usuario
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Si todo sale bien, el 'AuthGate' (nuestro guardia)
      // detectará el cambio y nos mandará al HomeScreen automáticamente.

    } on FirebaseAuthException catch (e) {
      // Manejo de errores de Firebase
      print("Error al registrar: $e");
      if (mounted) {
        setState(() {
          _errorMessage = e.message ?? 'Error desconocido al registrar.';
        });
      }
    }
  }

  // --- Lógica de Iniciar Sesión ---
  Future<void> _handleLogin() async {
    try {
      // Limpia errores anteriores
      if (mounted) setState(() { _errorMessage = ''; });

      final email = _emailController.text;
      final password = _passwordController.text;

      // Le pedimos a Firebase Auth que inicie sesión
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // De nuevo, si el login es exitoso, el 'AuthGate'
      // nos llevará al HomeScreen.

    } on FirebaseAuthException catch (e) {
      // Manejo de errores
      print("Error al iniciar sesión: $e");
      if (mounted) {
        setState(() {
          _errorMessage = 'Email o contraseña incorrectos.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión / Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de texto para el Email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),

            // Campo de texto para la Contraseña
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña (mín. 6 caracteres)',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Oculta la contraseña
            ),
            const SizedBox(height: 20),

            // --- Widget para mostrar Errores ---
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),

            // --- Botones ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón de Iniciar Sesión
                ElevatedButton(
                  onPressed: _handleLogin, // Llama a la función de login
                  child: const Text('Iniciar Sesión'),
                ),

                // Botón de Registrarse
                ElevatedButton(
                  onPressed: _handleRegister, // Llama a la función de registro
                  // ¡CAMBIO! Se eliminó la línea de 'style:' de aquí
                  child: const Text('Registrarse'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}