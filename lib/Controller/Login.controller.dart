import 'package:camera/camera.dart';
import 'package:facial/Api/Reconhecimento.api.dart';
import 'package:facial/Components/ToastMessage.component.dart';
import 'package:facial/Models/Usuario.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController {
  ReconhecimentoApi reconhecimentoApi = ReconhecimentoApi();

  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  Rxn<XFile> fotoReconhecimento = Rxn<XFile>();
  Rxn<UsuarioModel> usuario = Rxn<UsuarioModel>();

  Future<void> reconhecimento() async {
    try {
      if (fotoReconhecimento.value == null) {
        ToastMessageComponent.error(
          'Por favor, tire uma foto para reconhecer.',
        );
        return;
      }

      final response = await reconhecimentoApi.enviarFotoReconhecimento(
        fotoReconhecimento.value!,
      );

      if (response.statusCode == 200) {
        final body = response.body;

        if (body['reconhecido'] == true && body['usuario'] != null) {
          usuario.value = UsuarioModel.fromJson(body['usuario']);
          ToastMessageComponent.success(
            'Reconhecimento realizado com sucesso!',
          );
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
