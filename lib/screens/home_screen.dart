// Importar Flutter, Firebase Auth (para UID y logout) y Firebase Database
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

// --- Pantalla Principal (Panel de Control) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Obtenemos el ID del usuario actual
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  
  // Creamos una referencia a la base de datos de Firebase
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // --- Lógica de Cerrar Sesión ---
  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // El AuthGate nos redirigirá al Login
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  // --- Lógica para Enviar Comando de Reset ---
  Future<void> _handleReset() async {
    if (userId == null) return; // Seguridad por si el ID es nulo

    try {
      // Definimos la ruta del comando de reset para este usuario
      final resetPath = 'usuarios/$userId/comandos/reset';
      
      // Escribimos 'true' en esa ruta
      await _dbRef.child(resetPath).set(true);
      print("Comando de reseteo enviado.");
      
      // (Idealmente, el ESP32 pondría esto en 'false' al recibirlo)

    } catch (e) {
      print("Error al enviar comando de reset: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si por alguna razón el ID de usuario es nulo, mostramos error
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Error: No se pudo obtener el ID de usuario.'),
        ),
      );
    }

    // --- Esta es la ruta que vamos a "escuchar" ---
    // usuarios/[ID_DEL_USUARIO_LOGUEADO]/datos/conteo_actual
    final DatabaseReference conteoRef =
        _dbRef.child('usuarios/$userId/datos/conteo_actual');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Panel IoT'),
        actions: [
          // Botón para Cerrar Sesión
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Conteo Actual del Producto:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 20),

            // --- El Lector en Tiempo Real (StreamBuilder) ---
            StreamBuilder(
              // Le decimos que "escuche" los cambios en la ruta 'conteoRef'
              stream: conteoRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                // Caso 1: Si está cargando o conectando
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                // Caso 2: Si hubo un error
                if (!snapshot.hasData || snapshot.hasError || snapshot.data?.snapshot.value == null) {
                  print("Error o sin datos: ${snapshot.error}");
                  return const Text(
                    '0', // Muestra 0 si no hay dato o hay error
                    style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                  );
                }

                // Caso 3: ¡Tenemos datos!
                // El 'snapshot.data.snapshot.value' contiene el dato (ej: 5)
                final conteo = snapshot.data!.snapshot.value;

                return Text(
                  '$conteo', // Mostramos el valor leído
                  style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                );
              },
            ),

            const SizedBox(height: 50),

            // --- El Botón de Escritura (Comando) ---
            ElevatedButton(
              onPressed: _handleReset, // Llama a la función de reseteo
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Resetear Conteo', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}