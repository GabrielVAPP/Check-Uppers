class Remedio {
  String nome;
  DateTime horario;
  int repetirHoras; // 0 = não repetir

  Remedio({
    required this.nome,
    required this.horario,
    required this.repetirHoras,
  });

  // JSON
  Map<String, dynamic> toJson() => {
        'nome': nome,
        'horario': horario.toIso8601String(),
        'repetirHoras': repetirHoras,
      };

  factory Remedio.fromJson(Map<String, dynamic> json) => Remedio(
        nome: json['nome'],
        horario: DateTime.parse(json['horario']),
        repetirHoras: json['repetirHoras'],
      );
}
