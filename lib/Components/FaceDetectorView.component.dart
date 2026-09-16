import 'package:facial/Controller/FaceDetector.controller.dart';
import 'package:facial/Config/AppColors.config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

class FaceDetectionPreview extends StatelessWidget {
  const FaceDetectionPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final FaceDetectorController controller =
        Get.find<FaceDetectorController>();

    return Obx(() {
      final CameraController? camera = controller.cameraController;

      // Enquanto a câmera não estiver pronta.
      if (!controller.isInitialized.value ||
          camera == null ||
          !camera.value.isInitialized) {
        return const Center(child: CircularProgressIndicator());
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          // =====================================================
          // CÂMERA
          // =====================================================
          CameraPreview(camera),

          // =====================================================
          // MÁSCARA DO ROSTO
          // =====================================================
          ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcOut),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 280,
                    height: 360,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(180),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =====================================================
          // BORDA DO ROSTO
          // =====================================================
          Center(
            child: Obx(
              () => Container(
                width: 280,
                height: 360,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.rostoAproximado.value
                        ? Colors.green
                        : Colors.transparent,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(180),
                ),
              ),
            ),
          ),

          // =====================================================
          // BOTÃO FECHAR
          // =====================================================
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () async {
                await controller.encerrarCameraEDetector();

                if (Get.isBottomSheetOpen ?? false) {
                  Get.back(result: null);
                }
              },
            ),
          ),

          // =====================================================
          // MENSAGEM DE STATUS
          // =====================================================
          Positioned(
            top: 90,
            left: 20,
            right: 20,
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: controller.rostoAproximado.value
                      ? Colors.green.withOpacity(0.9)
                      : Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.statusMensagem.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // =====================================================
          // BOTÃO DA CÂMERA
          // =====================================================
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Obx(() {
              final bool podeTirarFoto =
                  controller.rostoAproximado.value &&
                  !controller.isCapturing.value;

              return Center(
                child: InkWell(
                  onTap: podeTirarFoto
                      ? () async {
                          final XFile? foto = await controller.salvarFoto();

                          if (foto == null) {
                            return;
                          }

                          final bool? desejarSalvar = await Get.dialog<bool>(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: const Text(
                                'Confirmar Foto',
                                style: TextStyle(color: AppColors.darkBlue),
                              ),
                              content: Text(
                                'Deseja salvar esta foto '
                                'ou tirar outra?',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back(result: false);
                                  },
                                  child: const Text(
                                    'Tirar outra',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back(result: true);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlue,
                                  ),
                                  child: const Text(
                                    'Salvar',
                                    style: TextStyle(
                                      color: AppColors.lightGray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            barrierDismissible: false,
                          );

                          // =================================================
                          // SALVAR
                          // =================================================
                          if (desejarSalvar == true) {
                            await controller.encerrarCameraEDetector();

                            if (Get.isBottomSheetOpen ?? false) {
                              Get.back(result: foto);
                            }

                            return;
                          }

                          // =================================================
                          // TIRAR OUTRA
                          // =================================================
                          if (desejarSalvar == false) {
                            await controller.retomarStream();
                          }
                        }
                      : null,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: podeTirarFoto ? Colors.green : Colors.grey,
                        width: 3,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: podeTirarFoto
                            ? Colors.green
                            : Colors.grey.shade400,
                      ),
                      child: controller.isCapturing.value
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 32,
                            ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}
