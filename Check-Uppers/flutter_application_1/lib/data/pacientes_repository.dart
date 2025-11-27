import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../models/paciente.dart';

class PacientesRepository {
  static List<Paciente> _pacientes = [];

  // Caminho do arquivo JSON
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/pacientes.json');
  }

  // ---------------------------------------------------------
  // 🔥 Carregar dados do arquivo ao iniciar
  // ---------------------------------------------------------
  static Future<void> carregarPacientes() async {
    try {
      final file = await _getFile();

      if (!file.existsSync()) {
        _pacientes = [];
        return;
      }

      final conteudo = await file.readAsString();

      final List jsonList = jsonDecode(conteudo);

      _pacientes =
          jsonList.map((json) => Paciente.fromJson(json)).toList();

    } catch (e) {
      print("Erro ao carregar pacientes: $e");
      _pacientes = [];
    }
  }

  // ---------------------------------------------------------
  // 🔥 Salvar dados no arquivo
  // ---------------------------------------------------------
  static Future<void> salvarPacientes() async {
    try {
      final file = await _getFile();

      final jsonList = _pacientes.map((p) => p.toJson()).toList();

      await file.writeAsString(jsonEncode(jsonList));

    } catch (e) {
      print("Erro ao salvar pacientes: $e");
    }
  }

  // ---------------------------------------------------------
  // Acesso à lista
  // ---------------------------------------------------------
  static List<Paciente> get pacientes => _pacientes;

  // ---------------------------------------------------------
  // Operações CRUD
  // ---------------------------------------------------------
  static Future<void> adicionar(Paciente p) async {
    _pacientes.add(p);
    await salvarPacientes();
  }

  static Future<void> remover(Paciente p) async {
    _pacientes.remove(p);
    await salvarPacientes();
  }

  static Future<void> atualizar(Paciente antigo, Paciente novo) async {
    final index = _pacientes.indexOf(antigo);
    if (index != -1) {
      _pacientes[index] = novo;
      await salvarPacientes();
    }
  }
}
