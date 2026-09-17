import 'package:camera/camera.dart';
import 'package:facial/Config/ApiClinte.config.dart';
import 'package:facial/Models/Usuario.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsuarioApi {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> cadastrarUsuario(UsuarioModel usuario) async {
    final formData = FormData({
      'nome': usuario.nome,
      'cpf': usuario.cpf ?? '',
      'email': usuario.email ?? '',
      if (usuario.foto != null)
        'foto': MultipartFile(usuario.foto!.path, filename: usuario.foto!.name),
    });

    debugPrint('=== BODY DA REQUISIÇÃO ===');
    for (var element in formData.fields) {
      debugPrint('Campo: ${element.key} = ${element.value}');
    }
    for (var element in formData.files) {
      debugPrint('Arquivo: ${element.key} = ${element.value.filename}');
    }
    debugPrint('===========================');

    return await _apiClient.post('/usuarios/', formData);
  }

  Future<Response> enviarFotoReconhecimento(XFile foto) async {
    final formData = FormData({
      'foto': MultipartFile(foto.path, filename: 'reconhecimento.jpg'),
    });

    return await _apiClient.post('/usuarios/reconhecer', formData);
  }
}
