import 'package:camera/camera.dart';
import 'package:facial/Api/Usuario.api.dart';
import 'package:facial/Components/ToastMessage.component.dart';
import 'package:facial/Models/Usuario.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UsuarioController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final UsuarioApi _usuarioApi = UsuarioApi();
  TextEditingController nome = TextEditingController();
  TextEditingController cpf = TextEditingController();
  TextEditingController email = TextEditingController();
  Rxn<XFile> foto = Rxn<XFile>();
  Rxn<XFile> fotoReconhecimento = Rxn<XFile>();
  Rxn<UsuarioModel> usuario = Rxn<UsuarioModel>();

  void limpaForm() {
    nome.text = '';
    cpf.text = '';
    email.text = '';
    foto.value = null;
  }

  Future<void> salvar() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (foto.value == null) {
      Get.snackbar('Atenção', 'Por favor, tire uma foto para o cadastro.');
      return;
    }

    if (nome.text.isEmpty) {
      Get.snackbar('Atenção', 'Informe o nome do usuário.');
      return;
    }

    try {
      final response = await _usuarioApi.cadastrarUsuario(
        UsuarioModel(
          nome: nome.text,
          cpf: cpf.text,
          email: email.text,
          foto: foto.value!,
        ),
      );

      print("teste vini ${response.statusCode}");

      if (response.statusCode == 200) {
        ToastMessageComponent.success(
          "${response.body['nome']} cadastrado com sucesso!",
        );
        limpaForm();
        return;
      }
      ToastMessageComponent.error(response.body['detail']['mensagem']);
    } catch (e) {
      ToastMessageComponent.error('Ocorreu um erro inesperado: $e');
    }
  }

  Future<void> reconhecimento() async {
    try {
      if (fotoReconhecimento.value == null) {
        ToastMessageComponent.error(
          'Por favor, tire uma foto para reconhecer.',
        );
        return;
      }

      final response = await _usuarioApi.enviarFotoReconhecimento(
        fotoReconhecimento.value!,
      );

      if (response.statusCode == 200) {
        final body = response.body;

        // Verifica se o usuário foi realmente reconhecido pelo backend
        if (body['reconhecido'] == true && body['usuario'] != null) {
          usuario.value = UsuarioModel.fromJson(body['usuario']);
          ToastMessageComponent.success(
            'Reconhecimento realizado com sucesso!',
          );
        } else {
          // Exibe a mensagem de falha retornada pela API ("Rosto não reconhecido", etc)
          final mensagem = body['mensagem'] ?? 'Rosto não reconhecido.';
          ToastMessageComponent.error(mensagem);
        }
      } else {
        ToastMessageComponent.error('Falha ao enviar reconhecimento.');
      }
    } catch (e) {
      ToastMessageComponent.error('Erro ao processar reconhecimento: $e');
    }
  }
}
