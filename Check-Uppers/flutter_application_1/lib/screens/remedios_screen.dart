import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../models/remedio.dart';
import '../data/pacientes_repository.dart';

class RemediosScreen extends StatefulWidget {
  final Paciente paciente;

  const RemediosScreen({super.key, required this.paciente});

  @override
  State<RemediosScreen> createState() => _RemediosScreenState();
}

class _RemediosScreenState extends State<RemediosScreen> {
  final _nomeController = TextEditingController();
  TimeOfDay? _hora;
  int repetirHoras = 0;

  Future<void> _selecionarHora() async {
    final h = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (h != null) setState(() => _hora = h);
  }

  // -------------------------------------------------------------
  // 🔥 ADICIONAR REMÉDIO
  // -------------------------------------------------------------
  void _adicionarRemedio() async {
    if (_nomeController.text.isEmpty || _hora == null) return;

    final hoje = DateTime.now();

    final horarioFinal = DateTime(
      hoje.year,
      hoje.month,
      hoje.day,
      _hora!.hour,
      _hora!.minute,
    );

    final novo = Remedio(
      nome: _nomeController.text,
      horario: horarioFinal,
      repetirHoras: repetirHoras,
    );

    setState(() {
      widget.paciente.remedios = [...widget.paciente.remedios, novo];
    });

    await PacientesRepository.salvarPacientes();

    _nomeController.clear();
    _hora = null;
    repetirHoras = 0;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Remédio adicionado!')),
    );
  }

  // -------------------------------------------------------------
  // 🔥 REMOVER REMÉDIO
  // -------------------------------------------------------------
  Future<void> _deletarRemedio(Remedio r) async {
    setState(() {
      widget.paciente.remedios.remove(r);
    });

    await PacientesRepository.salvarPacientes();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Remédio removido!')),
    );
  }

  // -------------------------------------------------------------
  // 🔧 EDITAR REMÉDIO
  // -------------------------------------------------------------
  void _editarRemedio(Remedio r) {
    final nomeEdit = TextEditingController(text: r.nome);
    final repetirEdit =
        TextEditingController(text: r.repetirHoras.toString());

    TimeOfDay horaEdit = TimeOfDay(
      hour: r.horario.hour,
      minute: r.horario.minute,
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Editar Remédio"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeEdit,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () async {
                  final h = await showTimePicker(
                    context: context,
                    initialTime: horaEdit,
                  );
                  if (h != null) {
                    setState(() => horaEdit = h);
                  }
                },
                child: Text(
                  "Horário: ${horaEdit.hour}:${horaEdit.minute.toString().padLeft(2, '0')}",
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: repetirEdit,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Repetir a cada (horas)",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),

            ElevatedButton(
              child: const Text("Salvar"),
              onPressed: () async {
                final hoje = DateTime.now();

                setState(() {
                  r.nome = nomeEdit.text;
                  r.repetirHoras = int.tryParse(repetirEdit.text) ?? 0;
                  r.horario = DateTime(
                    hoje.year,
                    hoje.month,
                    hoje.day,
                    horaEdit.hour,
                    horaEdit.minute,
                  );
                });

                await PacientesRepository.salvarPacientes();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Remédio atualizado!')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // -------------------------------------------------------------
  // UI
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final lista = widget.paciente.remedios;

    return Scaffold(
      appBar: AppBar(
        title: Text("Alarmes - ${widget.paciente.nome}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome do remédio",
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _selecionarHora,
              child: Text(
                _hora == null
                    ? "Selecionar horário"
                    : "Horário: ${_hora!.hour}:${_hora!.minute.toString().padLeft(2, '0')}",
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text("Repetir a cada "),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      repetirHoras = int.tryParse(v) ?? 0;
                    },
                  ),
                ),
                const Text(" horas"),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _adicionarRemedio,
              child: const Text("Adicionar Remédio"),
            ),

            const SizedBox(height: 25),
            const Divider(),
            const SizedBox(height: 10),

            const Text(
              "Remédios Registrados",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 12),

            ...lista.map((r) {
              return Card(
                child: ListTile(
                  title: Text(r.nome),
                  subtitle: Text(
                    "Horário: ${r.horario.hour}:${r.horario.minute.toString().padLeft(2, '0')}\n"
                    "Repetir: ${r.repetirHoras}h",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editarRemedio(r),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletarRemedio(r),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
