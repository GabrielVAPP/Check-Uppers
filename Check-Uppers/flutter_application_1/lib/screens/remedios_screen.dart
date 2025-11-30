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

  void _adicionarRemedio() async {
    if (_nomeController.text.isEmpty || _hora == null) return;

    final agora = DateTime.now();

    final horarioFinal = DateTime(
      agora.year,
      agora.month,
      agora.day,
      _hora!.hour,
      _hora!.minute,
    );

    final novo = Remedio(
      nome: _nomeController.text,
      horario: horarioFinal,
      repetirHoras: repetirHoras,
    );

    setState(() {
      widget.paciente.remedios.add(novo);
    });

    await PacientesRepository.salvarPacientes();

    _nomeController.clear();
    _hora = null;
    repetirHoras = 0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Remédio adicionado!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = widget.paciente.remedios;

    return Scaffold(
      appBar: AppBar(
        title: Text("Alarmes de Remédios - ${widget.paciente.nome}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: "Nome do remédio",
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _selecionarHora,
              child: Text(
                _hora == null
                    ? "Selecionar horário do alarme"
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
                    onChanged: (v) =>
                        repetirHoras = int.tryParse(v) ?? 0,
                  ),
                ),
                const Text(" horas"),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _adicionarRemedio,
              child: const Text("Adicionar Remédio"),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            const Text(
              "Remédios Registrados",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            ...lista.map((r) {
              return Card(
                child: ListTile(
                  title: Text(r.nome),
                  subtitle: Text(
                      "Horário: ${r.horario.hour}:${r.horario.minute.toString().padLeft(2, '0')}  "
                      "\nRepetir: ${r.repetirHoras}h"),
                  trailing: Icon(Icons.medication),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
