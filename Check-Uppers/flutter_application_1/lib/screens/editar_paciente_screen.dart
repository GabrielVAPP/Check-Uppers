import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../data/pacientes_repository.dart';

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
  DateTime? _fimTrat;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.paciente.nome);
    _generoController = TextEditingController(text: widget.paciente.genero);
    _anotacoesController =
        TextEditingController(text: widget.paciente.anotacoes ?? "");

    _dataNasc = widget.paciente.dataNascimento;
    _inicioTrat = widget.paciente.inicioTratamento;
    _fimTrat = widget.paciente.fimTratamento;
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
      fimTratamento: _fimTrat,
      anotacoes: _anotacoesController.text,
    );

    PacientesRepository.atualizar(widget.paciente, pacienteAtualizado);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paciente atualizado com sucesso!')),
    );

    Navigator.pop(context);
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
              onPressed: () => _selecionarData(
                  context, (d) => setState(() => _inicioTrat = d)),
              child: Text(_inicioTrat == null
                  ? 'Selecionar Início do Tratamento'
                  : 'Início: ${_inicioTrat!.day}/${_inicioTrat!.month}/${_inicioTrat!.year}'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () =>
                  _selecionarData(context, (d) => setState(() => _fimTrat = d)),
              child: Text(_fimTrat == null
                  ? 'Selecionar Fim do Tratamento (Opcional)'
                  : 'Fim: ${_fimTrat!.day}/${_fimTrat!.month}/${_fimTrat!.year}'),
            ),

            const SizedBox(height: 20),

            // 🔥 CAMPO DE ANOTAÇÕES
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
          ],
        ),
      ),
    );
  }
}
