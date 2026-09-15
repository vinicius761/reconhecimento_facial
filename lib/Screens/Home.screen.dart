import 'package:camera/camera.dart';
import 'package:facial/Components/FaceDetectorView.component.dart';
import 'package:facial/Controller/FaceDetector.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FaceDetectorController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reconhecimento Facial')),
      body: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return FaceDetectionPreview(
          cameraController: controller.cameraController!,
          faceCount: controller.faces.length,
        );
      }),
    );
  }
}
