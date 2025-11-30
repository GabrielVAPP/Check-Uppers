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
  void initState() {
    super.initState();

    // 🔄 Sempre atualizar quando entrar na tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  // ---------------------------------------------------------
  // 📌 CÁLCULO DA PRÓXIMA DOSE DE UM PACIENTE
  // ---------------------------------------------------------
  DateTime? _proximaDose(Paciente p) {
    if (p.remedios.isEmpty) return null;

    final agora = DateTime.now();
    DateTime? maisProxima;

    for (var r in p.remedios) {
      DateTime h = r.horario;

      // Ajusta horários passados
      while (h.isBefore(agora)) {
        if (r.repetirHoras <= 0) {
          h = agora.add(const Duration(days: 365));
          break;
        }
        h = h.add(Duration(hours: r.repetirHoras));
      }

      if (maisProxima == null || h.isBefore(maisProxima)) {
        maisProxima = h;
      }
    }

    return maisProxima;
  }

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
                final proxima = _proximaDose(paciente);

                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -----------------------------------------------
                        // 📌 NOME
                        // -----------------------------------------------
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
                            "Nascimento: ${paciente.dataNascimento.day}/${paciente.dataNascimento.month}/${paciente.dataNascimento.year}"),
                        Text(
                            "Início do Tratamento: ${paciente.inicioTratamento.day}/${paciente.inicioTratamento.month}/${paciente.inicioTratamento.year}"),

                        if (paciente.fimTratamento != null)
                          Text(
                            "Fim do Tratamento: ${paciente.fimTratamento!.day}/${paciente.fimTratamento!.month}/${paciente.fimTratamento!.year}",
                          ),

                        const SizedBox(height: 12),

                        // ------------------------------------------------------
                        // 📌 LISTA DE REMÉDIOS DO PACIENTE
                        // ------------------------------------------------------
                        if (paciente.remedios.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Remédios:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),

                              ...paciente.remedios.map((r) {
                                return Text(
                                  "• ${r.nome} — ${r.horario.hour}:${r.horario.minute.toString().padLeft(2, '0')}  (⟳ ${r.repetirHoras}h)",
                                  style: const TextStyle(fontSize: 14),
                                );
                              }).toList(),
                            ],
                          )
                        else
                          const Text(
                            "Nenhum remédio cadastrado",
                            style: TextStyle(color: Colors.grey),
                          ),

                        const SizedBox(height: 12),

                        // ------------------------------------------------------
                        // ⏰ PRÓXIMA DOSE
                        // ------------------------------------------------------
                        if (proxima != null)
                          Text(
                            "Próxima dose: "
                            "${proxima.hour.toString().padLeft(2, '0')}:"
                            "${proxima.minute.toString().padLeft(2, '0')}  "
                            "(${proxima.day}/${proxima.month})",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          const Text(
                            "Nenhuma dose futura",
                            style: TextStyle(color: Colors.grey),
                          ),

                        const SizedBox(height: 16),

                        // ------------------------------------------------------
                        // BOTÃO EDITAR
                        // ------------------------------------------------------
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
                              setState(() {}); // Atualiza ao voltar
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

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final novoPaciente = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegistrarPacienteScreen(),
            ),
          );

          // Garante que só adiciona quando retornar paciente válido
          if (novoPaciente is Paciente) {
            setState(() {});
          }
        },
      ),
    );
  }
}
