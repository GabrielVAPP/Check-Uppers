import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:flutter_application_1/data/pacientes_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar pacientes antes de iniciar a UI
  await PacientesRepository.carregarPacientes();

  runApp(const CuidadoresApp());
}

class CuidadoresApp extends StatelessWidget {
  const CuidadoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check-Uppers',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
