import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorController extends GetxController {
  CameraController? cameraController;
  final RxBool isInitialized = false.obs;
  final RxBool isProcessing = false.obs;
  final RxList<Face> faces = <Face>[].obs;

  late final FaceDetector _faceDetector;

  @override
  void onInit() {
    super.onInit();
    _initFaceDetector();
    _initCamera();
  }

  void _initFaceDetector() {
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableTracking: true,
    );
    _faceDetector = FaceDetector(options: options);
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await cameraController!.initialize();
    isInitialized.value = true;

    cameraController!.startImageStream(_processCameraImage);
  }

  void _processCameraImage(CameraImage image) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage != null) {
        final detectedFaces = await _faceDetector.processImage(inputImage);
        faces.assignAll(detectedFaces);
      }
    } catch (e) {
      print("Erro no processamento: $e");
    } finally {
      isProcessing.value = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (cameraController == null) return null;

    final camera = cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;
    final imageRotation =
        InputImageRotationValue.fromRawValue(sensorOrientation) ??
        InputImageRotation.rotation0deg;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null) return null;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: imageRotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  @override
  void onClose() {
    cameraController?.dispose();
    _faceDetector.close();
    super.onClose();
  }
}
