import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../data/pacientes_repository.dart';
import 'editar_paciente_screen.dart';
import 'registrar_paciente_screen.dart';

class ListaPacientesScreen extends StatefulWidget {
  const ListaPacientesScreen({super.key});

  @override
  State<ListaPacientesScreen> createState() => _ListaPacientesScreenState();
}

class _ListaPacientesScreenState extends State<ListaPacientesScreen> {
  List<Paciente> get pacientes => PacientesRepository.pacientes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Pacientes")),
      body: pacientes.isEmpty
          ? const Center(
              child: Text(
                "Nenhum paciente registrado",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: pacientes.length,
              itemBuilder: (context, index) {
                final paciente = pacientes[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paciente.nome,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text("Gênero: ${paciente.genero}"),
                        Text(
                            "Data de Nascimento: ${paciente.dataNascimento.day}/${paciente.dataNascimento.month}/${paciente.dataNascimento.year}"),
                        Text(
                            "Início do Tratamento: ${paciente.inicioTratamento.day}/${paciente.inicioTratamento.month}/${paciente.inicioTratamento.year}"),

                        if (paciente.fimTratamento != null)
                          Text(
                              "Fim do Tratamento: ${paciente.fimTratamento!.day}/${paciente.fimTratamento!.month}/${paciente.fimTratamento!.year}"),

                        const SizedBox(height: 8),

                        if (paciente.anotacoes != null &&
                            paciente.anotacoes!.trim().isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Anotações:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(paciente.anotacoes!),
                            ],
                          ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditarPacienteScreen(paciente: paciente),
                                ),
                              );

                              setState(() {}); // atualiza ao voltar
                            },
                            child: const Text("Editar"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // ➕ BOTÃO DE ADICIONAR PACIENTE (AGORA CORRETO)
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final novoPaciente = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegistrarPacienteScreen(),
            ),
          );

          // RegistrarPacienteScreen já adiciona o paciente automaticamente.
          // Aqui só atualizamos a tela.
          if (novoPaciente is Paciente) {
            setState(() {});
          }
        },
      ),
    );
  }
}
