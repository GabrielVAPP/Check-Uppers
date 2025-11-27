import 'package:flutter/material.dart';
import '../data/pacientes_repository.dart';
import 'registrar_paciente_screen.dart';

class GerenciarPacientesScreen extends StatefulWidget {
  const GerenciarPacientesScreen({super.key});

  @override
  State<GerenciarPacientesScreen> createState() =>
      _GerenciarPacientesScreenState();
}

class _GerenciarPacientesScreenState extends State<GerenciarPacientesScreen> {
  void _deletarPaciente(BuildContext context, int index) {
    final paciente = PacientesRepository.pacientes[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja deletar o paciente "${paciente.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                PacientesRepository.remover(paciente);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Paciente "${paciente.nome}" removido.')),
              );
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pacientes = PacientesRepository.pacientes;

    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Pacientes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('Registrar Novo Paciente'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegistrarPacienteScreen()),
                );
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Pacientes Registrados:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: pacientes.length,
                itemBuilder: (context, index) {
                  final p = pacientes[index];
                  return Card(
                    child: ListTile(
                      title: Text(p.nome),
                      subtitle: Text('Gênero: ${p.genero}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletarPaciente(context, index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
