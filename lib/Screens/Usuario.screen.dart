import 'package:facial/Components/Appbar.components.dart';
import 'package:facial/Components/Buttonbar.component.dart';
import 'package:facial/Components/FormField.component.dart';
import 'package:facial/Components/FotoPreview.conponent.dart';
import 'package:facial/Controller/FaceDetector.controller.dart';
import 'package:facial/Controller/Usuario.controller.dart';
import 'package:facial/Config/AppColors.config.dart';
import 'package:facial/Utils/Validators.utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsuarioScreen extends StatelessWidget {
  const UsuarioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsuarioController>();
    final faceController = Get.find<FaceDetectorController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBarComponent(
          title: 'Cadastro de Usuário',
          bottom: const TabBar(
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primaryBlue,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            tabs: [
              Tab(text: 'Cadastro'),
              Tab(text: 'Reconhecimento'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: TabBarView(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      FormFieldComponent(
                        label: 'Nome',
                        hint: 'Digite seu nome',
                        controller: controller.nome,
                        validator: (value) => Validators.campoVazio(
                          value,
                          mensagem: 'Informe o nome ',
                        ),
                      ),
                      const SizedBox(height: 12),
                      FormFieldComponent(
                        label: 'CPF',
                        hint: 'Digite seu CPF',
                        controller: controller.cpf,
                        validator: (value) => Validators.campoVazio(
                          value,
                          mensagem: 'Informe o CPF',
                        ),
                      ),
                      const SizedBox(height: 12),
                      FormFieldComponent(
                        label: 'Email',
                        hint: 'Digite seu e-mail',
                        controller: controller.email,
                        validator: (value) => Validators.campoVazio(
                          value,
                          mensagem: 'Informe o nome email',
                        ),
                      ),
                      const SizedBox(height: 12),
                      FotoPreviewWidget(
                        fotoRx: controller.foto,
                        onTirarFoto: () =>
                            faceController.abrirModalReconhecimentoFacial(),
                        labelBotaoTirar: 'Registrar foto',
                        labelBotaoTrocar: 'Tirar outra foto',

                        alturaPreview: 200,
                      ),
                      const SizedBox(height: 24),
                      // Botão Salvar dentro da Column da primeira aba
                      ButtonbarComponent(
                        label: 'Salvar',
                        onPress: controller.salvar,
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Aba de Reconhecimento (Sem o botão)
              SingleChildScrollView(
                child: Center(
                  child: FotoPreviewWidget(
                    fotoRx: controller.fotoReconhecimento,
                    onTirarFoto: () =>
                        faceController.abrirModalReconhecimentoFacial(),
                    labelBotaoTirar: 'Registrar foto',
                    labelBotaoTrocar: 'Tirar outra foto',
                    alturaPreview: 200,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
