import 'package:facial/Controller/FaceDetector.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

class FaceDetectionPreview extends StatelessWidget {
  final bool capturaAutomatica;

  const FaceDetectionPreview({super.key, this.capturaAutomatica = false});

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
          // MÁSCARA DO ROSTO (Fundo escuro sem a parte branca)
          // =====================================================
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.black54,
              BlendMode.srcOut,
            ),
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
                      color: Colors.transparent,
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
          // BOTÃO DA CÂMERA (Oculto se capturaAutomatica == true)
          // =====================================================
          if (!capturaAutomatica)
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
                        ? () => controller.processarFotoEConfirmar()
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
