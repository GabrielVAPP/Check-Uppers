class Paciente {
  String nome;
  DateTime dataNascimento;
  String genero;
  DateTime inicioTratamento;
  DateTime? fimTratamento;
  String? anotacoes;

  Paciente({
    required this.nome,
    required this.dataNascimento,
    required this.genero,
    required this.inicioTratamento,
    this.fimTratamento,
    this.anotacoes,
  });

  // ---------- JSON ----------

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'dataNascimento': dataNascimento.toIso8601String(),
      'genero': genero,
      'inicioTratamento': inicioTratamento.toIso8601String(),
      'fimTratamento': fimTratamento?.toIso8601String(),
      'anotacoes': anotacoes,
    };
  }

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      nome: json['nome'],
      dataNascimento: DateTime.parse(json['dataNascimento']),
      genero: json['genero'],
      inicioTratamento: DateTime.parse(json['inicioTratamento']),
      fimTratamento:
          json['fimTratamento'] != null ? DateTime.parse(json['fimTratamento']) : null,
      anotacoes: json['anotacoes'],
    );
  }
}
