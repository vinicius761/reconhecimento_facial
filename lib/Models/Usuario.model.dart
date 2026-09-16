import 'package:camera/camera.dart';

class UsuarioModel {
  final String nome;
  final String? cpf;
  final String? email;
  final XFile? foto;

  UsuarioModel({required this.nome, this.cpf, this.email, this.foto});

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      nome: json['nome'] ?? '',
      cpf: json['cpf'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nome': nome, 'cpf': cpf, 'email': email};
  }
}
