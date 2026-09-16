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

    // --- PRINTS DO BODY (FormData) ---
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

  Future<Response> enviarFotoReconhecimento(FormData formData) async {
    return await _apiClient.post('/usuarios/reconhecimento', formData);
  }
}
