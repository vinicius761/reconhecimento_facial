import 'package:facial/Controller/FaceDetector.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:camera/camera.dart';

class FaceDetectionPreview extends StatelessWidget {
  final CameraController cameraController;
  final int faceCount;
  final Widget? overlay;

  const FaceDetectionPreview({
    super.key,
    required this.cameraController,
    required this.faceCount,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(cameraController),
        overlay ??
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Rostos detectados: $faceCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
      ],
    );
  }
}
