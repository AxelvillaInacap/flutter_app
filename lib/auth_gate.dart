import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Importamos las pantallas que VAMOS a crear (aún no existen, dará error)
import 'package:evaluacion_app/screens/home_screen.dart';
import 'package:evaluacion_app/screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Aquí "escuchamos" en tiempo real los cambios de autenticación
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si el 'snapshot' (la foto instantánea) no tiene datos...
        if (!snapshot.hasData) {
          // ...significa que el usuario NO está logueado.
          // Lo mandamos a la pantalla de Login.
          return const LoginScreen();
        }

        // Si SÍ tiene datos, significa que el usuario está logueado.
        // Lo mandamos a la pantalla principal (Home).
        return const HomeScreen();
      },
    );
  }
}