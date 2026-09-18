import 'package:flutter/material.dart';

class MenuItemModel {
  final int id;
  final String titulo;
  final String descricao;
  final String icone;
  final String rota;

  MenuItemModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.rota,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      icone: json['icone'] as String,
      rota: json['rota'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'icone': icone,
      'rota': rota,
    };
  }

  // Getter auxiliar para mapear a String da API para IconData do Material Icons
  IconData get iconData {
    switch (icone) {
      case 'camera_alt_outlined':
        return Icons.camera_alt_outlined;
      case 'history':
        return Icons.history;
      case 'upload_file_outlined':
        return Icons.upload_file_outlined;
      case 'receipt_long_outlined':
        return Icons.receipt_long_outlined;
      case 'beach_access_outlined':
        return Icons.beach_access_outlined;
      case 'description_outlined':
        return Icons.description_outlined;
      case 'access_time_outlined':
        return Icons.access_time_outlined;
      case 'person_outline':
        return Icons.person_outline;
      default:
        return Icons.widgets_outlined;
    }
  }
}
