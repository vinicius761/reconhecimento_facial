import 'package:facial/Components/Buttonbar.component.dart';
import 'package:facial/Components/FormField.component.dart';
import 'package:facial/Components/FotoPreview.conponent.dart';
import 'package:facial/Config/AppColors.config.dart';
import 'package:facial/Controller/FaceDetector.controller.dart';
import 'package:facial/Controller/Login.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.find<LoginController>();
    FaceDetectorController faceController = Get.find<FaceDetectorController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FormFieldComponent(
                label: 'E-mail',
                hint: 'Digite e-mail',
                controller: controller.email,
              ),
              SizedBox(height: 16),
              FormFieldComponent(
                label: 'Senha',
                hint: 'Digite senha',
                controller: controller.senha,
                // enabled: false,
              ),
              SizedBox(height: 16),
              ButtonbarComponent(
                label: 'Entrar',
                onPress: () => controller.salvar(),
                loading: false,
              ),

              SizedBox(height: 16),
              FotoPreviewWidget(
                fotoRx: controller.fotoReconhecimento,
                onTirarFoto: () async {
                  final foto = await faceController
                      .abrirModalReconhecimentoFacialAutomatico();

                  if (foto != null) {
                    controller.fotoReconhecimento.value = foto;
                    controller.loginBiometria();
                  }
                },
                labelBotaoTirar: 'Entrar com biometria',
                labelBotaoTrocar: 'Tirar outra foto',
                alturaPreview: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
