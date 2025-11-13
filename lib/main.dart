// Importamos el paquete de material design (para los widgets)
import 'package:flutter/material.dart';

// Importa el paquete "núcleo" de Firebase
import 'package:firebase_core/firebase_core.dart';

// Importa el archivo que 'flutterfire' creó automáticamente para nosotros
import 'firebase_options.dart';

import 'package:evaluacion_app/auth_gate.dart';

// Esta es la función principal que se ejecuta primero
Future<void> main() async {
  // Asegúrate de que Flutter esté listo antes de hacer nada de Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // ¡Aquí es donde "encendemos" Firebase!
  // Usamos el archivo firebase_options.dart para cargar la configuración correcta
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Le decimos a Flutter que corra nuestra aplicación
  runApp(const MyApp());
}

// Esta es la raíz de tu aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Desactiva la bandita de "DEBUG" en la esquina
      debugShowCheckedModeBanner: false,
      title: 'Evaluación 3 IoT',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      // Por ahora, solo mostramos una pantalla simple
      home: const AuthGate(),
    );
  }
}