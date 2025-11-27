import 'package:flutter/material.dart';
import 'lista_pacientes_screen.dart';
import 'gerenciar_pacientes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-uppers'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Lista de Pacientes'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ListaPacientesScreen()));
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.manage_accounts),
              label: const Text('Gerenciar Pacientes'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const GerenciarPacientesScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
