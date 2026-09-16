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

      if (response.statusCode == 200) {
        ToastMessageComponent.success(response.body['detail']['mensagem']);
        LimpaForm();
        return;
      }
      ToastMessageComponent.error(response.body['detail']['mensagem']);
    } catch (e) {
      ToastMessageComponent.error('Ocorreu um erro inesperado: $e');
    }
  }

  LimpaForm() {
    nome.text = '';
    cpf.text = '';
    email.text = '';
    foto.value = null;
  }
}
