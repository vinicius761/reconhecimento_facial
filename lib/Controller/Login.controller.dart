import 'package:camera/camera.dart';
import 'package:facial/Api/Autenticacao.api.dart';
import 'package:facial/AppRoutes.dart';
import 'package:facial/Components/ToastMessage.component.dart';
import 'package:facial/Models/Usuario.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';

class LoginController extends GetxController {
  AutenticacaoApi authApi = AutenticacaoApi();

  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  Rxn<XFile> fotoReconhecimento = Rxn<XFile>();
  Rxn<UsuarioModel> usuario = Rxn<UsuarioModel>();
  RxString token = ''.obs;

  Future<void> loginBiometria() async {
    try {
      if (fotoReconhecimento.value == null) {
        ToastMessageComponent.error(
          'Por favor, tire uma foto para reconhecer.',
        );
        return;
      }

      final response = await authApi.loginFacial(fotoReconhecimento.value!);

      if (response.statusCode == 200) {
        final body = response.body;

        if (body['sucesso'] == true && body['usuario'] != null) {
          usuario.value = UsuarioModel.fromJson(body['usuario']);
          print('okok ${usuario.value}');
          token.value = body['access_token'];
          ToastMessageComponent.success(
            'Reconhecimento realizado com sucesso!',
          );
          Get.toNamed(AppRoutes.home);
        } else {
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

  salvar() {}
}
