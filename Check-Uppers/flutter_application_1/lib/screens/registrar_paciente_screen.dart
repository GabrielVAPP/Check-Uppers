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
  DateTime? _fimTrat;

  Future<void> _selecionarData(BuildContext context, Function(DateTime) setData) async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (data != null) setData(data);
  }

  void _salvar() {
    if (_formKey.currentState!.validate() && _dataNasc != null && _inicioTrat != null) {
      final novoPaciente = Paciente(
        nome: _nomeController.text,
        dataNascimento: _dataNasc!,
        genero: _generoController.text,
        inicioTratamento: _inicioTrat!,
        fimTratamento: _fimTrat,
      );
      PacientesRepository.adicionar(novoPaciente);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paciente "${novoPaciente.nome}" registrado com sucesso!')),
      );
      Navigator.pop(context);
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
                onPressed: () => _selecionarData(context, (d) => setState(() => _dataNasc = d)),
                child: Text(_dataNasc == null
                    ? 'Selecionar Data de Nascimento'
                    : 'Nascimento: ${_dataNasc!.day}/${_dataNasc!.month}/${_dataNasc!.year}'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _selecionarData(context, (d) => setState(() => _inicioTrat = d)),
                child: Text(_inicioTrat == null
                    ? 'Selecionar Início do Tratamento'
                    : 'Início: ${_inicioTrat!.day}/${_inicioTrat!.month}/${_inicioTrat!.year}'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _selecionarData(context, (d) => setState(() => _fimTrat = d)),
                child: Text(_fimTrat == null
                    ? 'Selecionar Fim do Tratamento (Opcional)'
                    : 'Fim: ${_fimTrat!.day}/${_fimTrat!.month}/${_fimTrat!.year}'),
              ),
              const SizedBox(height: 20),
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
