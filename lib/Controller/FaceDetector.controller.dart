import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:facial/Components/FaceDetectorView.component.dart';
import 'package:facial/Config/AppColors.config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorController extends GetxController {
  CameraController? cameraController;
  FaceDetector? _faceDetector;

  final RxBool isInitialized = false.obs;
  final RxBool isProcessing = false.obs;
  final RxList<Face> faces = <Face>[].obs;

  final RxString statusMensagem = 'Aproxime seu rosto'.obs;
  final RxBool rostoAproximado = false.obs;
  final RxBool isCapturing = false.obs;

  bool _isInitializing = false;
  bool _isDisposing = false;
  int _cameraSession = 0;

  Worker? _autoCaptureWorker;
  Timer? _countdownTimer;

  Future<void> iniciarDetectorECamera() async {
    if (_isDisposing) {
      return;
    }

    if (isInitialized.value &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      return;
    }

    if (_isInitializing) {
      while (_isInitializing && !_isDisposing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }

      return;
    }

    _isInitializing = true;
    isInitialized.value = false;

    final int session = ++_cameraSession;

    limparEstado();

    try {
      await _disposeCameraOnly();

      if (_isDisposing || session != _cameraSession) {
        return;
      }

      await _closeFaceDetector();

      if (_isDisposing || session != _cameraSession) {
        return;
      }

      final options = FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableTracking: true,
      );

      _faceDetector = FaceDetector(options: options);

      final cameras = await availableCameras();

      if (_isDisposing || session != _cameraSession) {
        return;
      }

      if (cameras.isEmpty) {
        throw Exception('Nenhuma câmera encontrada no dispositivo.');
      }

      final CameraDescription frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final CameraController newCameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      cameraController = newCameraController;

      await newCameraController.initialize();

      if (_isDisposing || session != _cameraSession) {
        await newCameraController.dispose();

        if (identical(cameraController, newCameraController)) {
          cameraController = null;
        }

        return;
      }

      if (!newCameraController.value.isInitialized) {
        throw Exception('A câmera não foi inicializada corretamente.');
      }

      isInitialized.value = true;

      await newCameraController.startImageStream(_processCameraImage);

      if (_isDisposing || session != _cameraSession) {
        return;
      }

      debugPrint('CÂMERA INICIALIZADA COM SUCESSO - sessão: $session');
    } catch (e, stackTrace) {
      debugPrint('ERRO AO INICIALIZAR CÂMERA/DETECTOR: $e');

      debugPrint(stackTrace.toString());

      isInitialized.value = false;

      await _disposeCameraOnly();
      await _closeFaceDetector();

      cameraController = null;
      _faceDetector = null;

      statusMensagem.value = 'Não foi possível iniciar a câmera';
    } finally {
      _isInitializing = false;
    }
  }

  void limparEstado() {
    rostoAproximado.value = false;
    statusMensagem.value = 'Aproxime seu rosto';
    faces.clear();
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDisposing || isCapturing.value || isProcessing.value) {
      return;
    }

    if (_faceDetector == null) {
      return;
    }

    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    isProcessing.value = true;

    try {
      final InputImage? inputImage = _inputImageFromCameraImage(image);

      if (inputImage == null) {
        return;
      }

      final FaceDetector? detector = _faceDetector;

      if (detector == null) {
        return;
      }

      final List<Face> detectedFaces = await detector.processImage(inputImage);

      if (_isDisposing) {
        return;
      }

      if (!identical(detector, _faceDetector)) {
        return;
      }

      faces.assignAll(detectedFaces);

      if (detectedFaces.isNotEmpty) {
        final Size imageSize = Size(
          image.width.toDouble(),
          image.height.toDouble(),
        );

        _validarProximidadeEPosicao(detectedFaces.first, imageSize);
      } else {
        rostoAproximado.value = false;
        statusMensagem.value = 'Nenhum rosto encontrado';
      }
    } catch (e) {
      debugPrint('Erro no processamento da imagem: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  void _validarProximidadeEPosicao(Face face, Size imageSize) {
    final double faceWidth = face.boundingBox.width;
    final double faceHeight = face.boundingBox.height;

    const double minSizeRatio = 0.40;

    final bool tamanhoAdequado =
        faceWidth > (imageSize.width * minSizeRatio) &&
        faceHeight > (imageSize.width * minSizeRatio);

    final double rotY = face.headEulerAngleY ?? 0;
    final double rotZ = face.headEulerAngleZ ?? 0;

    final bool estaDeFrente = rotY.abs() < 12 && rotZ.abs() < 12;

    if (!tamanhoAdequado) {
      rostoAproximado.value = false;
      statusMensagem.value = 'Chegue mais perto da câmera';
    } else if (!estaDeFrente) {
      rostoAproximado.value = false;
      statusMensagem.value = 'Olhe para a tela';
    } else {
      rostoAproximado.value = true;
      statusMensagem.value = 'Posição ideal! Mantenha parado...';
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final CameraController? controller = cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return null;
    }

    final CameraDescription camera = controller.description;
    final int sensorOrientation = camera.sensorOrientation;

    final InputImageRotation imageRotation =
        InputImageRotationValue.fromRawValue(sensorOrientation) ??
        InputImageRotation.rotation0deg;

    final InputImageFormat? format = InputImageFormatValue.fromRawValue(
      image.format.raw,
    );

    if (format == null) {
      return null;
    }

    final WriteBuffer allBytes = WriteBuffer();

    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final Uint8List bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: imageRotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Future<void> encerrarCameraEDetector() async {
    if (_isDisposing) {
      return;
    }

    _isDisposing = true;
    _cameraSession++;

    _countdownTimer?.cancel();
    _countdownTimer = null;

    isInitialized.value = false;
    isProcessing.value = false;
    isCapturing.value = false;

    limparEstado();

    try {
      await _disposeCameraOnly();
    } catch (e) {
      debugPrint('Erro ao encerrar câmera: $e');
    }

    try {
      await _closeFaceDetector();
    } catch (e) {
      debugPrint('Erro ao encerrar FaceDetector: $e');
    }

    cameraController = null;
    _faceDetector = null;

    _isInitializing = false;
    _isDisposing = false;
  }

  Future<void> _disposeCameraOnly() async {
    final CameraController? controller = cameraController;

    if (controller == null) {
      return;
    }

    cameraController = null;

    try {
      if (controller.value.isInitialized &&
          controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } catch (e) {
      debugPrint('Erro ao parar image stream: $e');
    }

    try {
      await controller.dispose();
    } catch (e) {
      debugPrint('Erro ao fazer dispose da câmera: $e');
    }
  }

  Future<void> _closeFaceDetector() async {
    final FaceDetector? detector = _faceDetector;

    if (detector == null) {
      return;
    }

    _faceDetector = null;

    try {
      await detector.close();
    } catch (e) {
      debugPrint('Erro ao fechar detector: $e');
    }
  }

  Future<void> retomarStream() async {
    if (_isDisposing) {
      return;
    }

    try {
      isCapturing.value = false;
      limparEstado();

      final CameraController? controller = cameraController;

      if (controller == null || !controller.value.isInitialized) {
        await iniciarDetectorECamera();
        return;
      }

      if (!controller.value.isStreamingImages) {
        await controller.startImageStream(_processCameraImage);
      }

      isInitialized.value = true;

      debugPrint('Image stream retomado com sucesso.');
    } catch (e) {
      debugPrint('Erro ao retomar stream: $e');

      isInitialized.value = false;

      await iniciarDetectorECamera();
    }
  }

  Future<XFile?> salvarFoto() async {
    final CameraController? controller = cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return null;
    }

    if (isCapturing.value) {
      return null;
    }

    try {
      isCapturing.value = true;

      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }

      final XFile file = await controller.takePicture();

      return file;
    } catch (e) {
      debugPrint('Erro ao tirar foto: $e');

      await retomarStream();

      return null;
    } finally {
      isCapturing.value = false;
    }
  }

  // =========================================================
  // LOGICA PARA MODO MANUAL (Com botão + Diálogo de Confirmação)
  // =========================================================
  Future<void> processarFotoEConfirmar() async {
    final XFile? foto = await salvarFoto();
    if (foto == null) return;

    final bool? desejarSalvar = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Confirmar Foto',
          style: TextStyle(color: AppColors.darkBlue),
        ),
        content: const Text(
          'Deseja salvar esta foto ou tirar outra?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Tirar outra',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
            ),
            child: const Text(
              'Salvar',
              style: TextStyle(color: AppColors.lightGray),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (desejarSalvar == true) {
      await encerrarCameraEDetector();
      if (Get.isBottomSheetOpen ?? false) {
        Get.back(result: foto);
      }
    } else if (desejarSalvar == false) {
      await retomarStream();
    }
  }

  // =========================================================
  // LOGICA PARA MODO AUTOMÁTICO (Sem botão + Fecha Imediato)
  // =========================================================
  Future<void> processarFotoEConfirmarAutomatico() async {
    if (isCapturing.value) return;

    final XFile? foto = await salvarFoto();
    if (foto == null) return;

    await encerrarCameraEDetector();

    if (Get.isBottomSheetOpen ?? false) {
      Get.back(result: foto);
    }
  }

  Future<XFile?> abrirModalReconhecimentoFacial() async {
    _autoCaptureWorker?.dispose();
    _countdownTimer?.cancel();
    _countdownTimer = null;

    await iniciarDetectorECamera();

    if (!isInitialized.value ||
        cameraController == null ||
        !cameraController!.value.isInitialized) {
      Get.snackbar(
        'Erro',
        'Não foi possível iniciar a câmera.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return null;
    }

    final XFile? fotoCapturada = await Get.bottomSheet<XFile?>(
      SizedBox(
        height: Get.height,
        width: Get.width,
        child: const Scaffold(
          backgroundColor: Colors.black,
          body: FaceDetectionPreview(capturaAutomatica: false),
        ),
      ),
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.black,
    );

    return fotoCapturada;
  }

  Future<XFile?> abrirModalReconhecimentoFacialAutomatico() async {
    _autoCaptureWorker?.dispose();
    _countdownTimer?.cancel();
    _countdownTimer = null;

    // Escuta o alinhamento do rosto com delay de 2 segundos
    _autoCaptureWorker = ever(rostoAproximado, (bool detectado) {
      if (!detectado) {
        _countdownTimer?.cancel();
        _countdownTimer = null;
        return;
      }

      if (detectado && !isCapturing.value && _countdownTimer == null) {
        _countdownTimer = Timer(const Duration(seconds: 2), () {
          if (rostoAproximado.value && !isCapturing.value) {
            processarFotoEConfirmarAutomatico();
          }
          _countdownTimer = null;
        });
      }
    });

    await iniciarDetectorECamera();

    if (!isInitialized.value ||
        cameraController == null ||
        !cameraController!.value.isInitialized) {
      _countdownTimer?.cancel();
      _autoCaptureWorker?.dispose();

      Get.snackbar(
        'Erro',
        'Não foi possível iniciar a câmera.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return null;
    }

    final XFile? fotoCapturada = await Get.bottomSheet<XFile?>(
      SizedBox(
        height: Get.height,
        width: Get.width,
        child: const Scaffold(
          backgroundColor: Colors.black,
          body: FaceDetectionPreview(capturaAutomatica: true),
        ),
      ),
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.black,
    );

    _countdownTimer?.cancel();
    _autoCaptureWorker?.dispose();

    print("retona automatico ${fotoCapturada}");
    return fotoCapturada;
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _autoCaptureWorker?.dispose();
    unawaited(encerrarCameraEDetector());
    super.onClose();
  }
}
