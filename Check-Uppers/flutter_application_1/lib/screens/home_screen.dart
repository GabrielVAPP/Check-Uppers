import 'package:flutter/material.dart';
import '../data/pacientes_repository.dart';
import 'lista_pacientes_screen.dart';
import 'gerenciar_pacientes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  int calcularIdade(DateTime nascimento) {
    final hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;

    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }

    return idade;
  }

  @override
  Widget build(BuildContext context) {
    final pacientes = PacientesRepository.pacientes;
    final total = pacientes.length;

    // Exibir no máximo 3 pacientes
    final listaCompacta = pacientes.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-uppers'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 🔹 Card: Total de Pacientes
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Total de Pacientes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$total',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Mini-lista de pacientes
            const Text(
              'Pacientes Recentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            if (listaCompacta.isEmpty)
              const Text("Nenhum paciente registrado ainda."),

            ...listaCompacta.map((paciente) {
              final idade = calcularIdade(paciente.dataNascimento);

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(paciente.nome),
                  subtitle: Text("Idade: $idade  |  Gênero: ${paciente.genero}"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ListaPacientesScreen(),
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 20),

            // 🔹 Botões
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Lista de Pacientes'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListaPacientesScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              icon: const Icon(Icons.manage_accounts),
              label: const Text('Gerenciar Pacientes'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GerenciarPacientesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
