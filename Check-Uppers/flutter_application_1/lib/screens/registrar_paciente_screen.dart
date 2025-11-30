import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../data/pacientes_repository.dart';

class RegistrarPacienteScreen extends StatefulWidget {
  const RegistrarPacienteScreen({super.key});

  @override
  State<RegistrarPacienteScreen> createState() =>
      _RegistrarPacienteScreenState();
}

class _RegistrarPacienteScreenState extends State<RegistrarPacienteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _generoController = TextEditingController();

  DateTime? _dataNasc;
  DateTime? _inicioTrat;

  String? anotacoes;

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

  void _editarAnotacoes() {
    final controller = TextEditingController(text: anotacoes ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Anotações"),
        content: TextField(
          controller: controller,
          maxLines: 6,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => anotacoes = controller.text);
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _salvar() {
    if (_formKey.currentState!.validate() &&
        _dataNasc != null &&
        _inicioTrat != null) {
      final novoPaciente = Paciente(
        nome: _nomeController.text,
        genero: _generoController.text,
        dataNascimento: _dataNasc!,
        inicioTratamento: _inicioTrat!,
        anotacoes: anotacoes,
      );

      PacientesRepository.adicionar(novoPaciente);
      Navigator.pop(context, novoPaciente);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
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
              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.note_alt),
                label: Text(
                  anotacoes == null || anotacoes!.isEmpty
                      ? "Adicionar Anotações"
                      : "Editar Anotações",
                ),
                onPressed: _editarAnotacoes,
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
