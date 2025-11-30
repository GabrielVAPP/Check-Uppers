import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../data/pacientes_repository.dart';
import 'remedios_screen.dart';

class EditarPacienteScreen extends StatefulWidget {
  final Paciente paciente;

  const EditarPacienteScreen({super.key, required this.paciente});

  @override
  State<EditarPacienteScreen> createState() => _EditarPacienteScreenState();
}

class _EditarPacienteScreenState extends State<EditarPacienteScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _generoController;
  late TextEditingController _anotacoesController;

  DateTime? _dataNasc;
  DateTime? _inicioTrat;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.paciente.nome);
    _generoController = TextEditingController(text: widget.paciente.genero);
    _anotacoesController =
        TextEditingController(text: widget.paciente.anotacoes ?? "");

    _dataNasc = widget.paciente.dataNascimento;
    _inicioTrat = widget.paciente.inicioTratamento;
  }

  Future<void> _selecionarData(
      BuildContext context, Function(DateTime) setData) async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (data != null) setData(data);
  }

  void _salvar() {
    final pacienteAtualizado = Paciente(
      nome: _nomeController.text,
      genero: _generoController.text,
      dataNascimento: _dataNasc!,
      inicioTratamento: _inicioTrat!,
      anotacoes: _anotacoesController.text,
    );

    PacientesRepository.atualizar(widget.paciente, pacienteAtualizado);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paciente atualizado com sucesso!')),
    );

    Navigator.pop(context);
  }

  void _confirmarDelecao() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Deletar Paciente"),
        content: const Text(
            "Tem certeza que deseja deletar este paciente? Esta ação não pode ser desfeita."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              PacientesRepository.remover(widget.paciente);
              Navigator.pop(context); // fecha o diálogo
              Navigator.pop(context, "deleted"); // volta para listagem
            },
            child: const Text("Deletar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _generoController,
              decoration: const InputDecoration(labelText: 'Gênero'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () =>
                  _selecionarData(context, (d) => setState(() => _dataNasc = d)),
              child: Text(_dataNasc == null
                  ? 'Selecionar Data de Nascimento'
                  : 'Nascimento: ${_dataNasc!.day}/${_dataNasc!.month}/${_dataNasc!.year}'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () =>
                  _selecionarData(context, (d) => setState(() => _inicioTrat = d)),
              child: Text(_inicioTrat == null
                  ? 'Selecionar Início do Tratamento'
                  : 'Início: ${_inicioTrat!.day}/${_inicioTrat!.month}/${_inicioTrat!.year}'),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RemediosScreen(paciente: widget.paciente),
                  ),
                );
              },
              icon: const Icon(Icons.medication),
              label: const Text("Gerenciar Remédios"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _anotacoesController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Anotações',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar Alterações'),
            ),

            const SizedBox(height: 20),

            // 🔥 BOTÃO DELETAR PACIENTE
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: _confirmarDelecao,
              child: const Text("Deletar Paciente"),
            ),
          ],
        ),
      ),
    );
  }
}
