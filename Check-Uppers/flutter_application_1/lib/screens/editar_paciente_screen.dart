import 'package:flutter/material.dart';
import '../models/paciente.dart';

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

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.paciente.nome);
    _generoController = TextEditingController(text: widget.paciente.genero);
    _anotacoesController = TextEditingController(text: widget.paciente.anotacoes ?? "");
  }

  void _salvar() {
    setState(() {
      widget.paciente.nome = _nomeController.text;
      widget.paciente.genero = _generoController.text;
      widget.paciente.anotacoes = _anotacoesController.text;
    });

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
