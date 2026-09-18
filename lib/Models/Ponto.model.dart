import 'package:intl/intl.dart';

class PontoModel {
  final int id;
  final String tipo;
  final DateTime horario;

  PontoModel({required this.id, required this.tipo, required this.horario});

  factory PontoModel.fromJson(Map<String, dynamic> json) {
    return PontoModel(
      id: json['id'] as int,
      tipo: json['tipo'] as String,
      horario: DateTime.parse(json['horario'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'horario': horario.toUtc().toIso8601String(),
    };
  }

  // Getters formatados usando intl
  String get dataFormatada =>
      DateFormat('dd/MM/yyyy').format(horario.toLocal());

  String get horaFormatada => DateFormat('HH:mm').format(horario.toLocal());

  String get dataEHoraFormatada =>
      DateFormat("dd/MM/yyyy 'às' HH:mm").format(horario.toLocal());
}
