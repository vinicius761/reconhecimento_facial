import 'package:facial/Config/ApiClinte.config.dart';
import 'package:facial/Controller/FaceDetector.controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceDetectorController>(
      () => FaceDetectorController(),
      fenix: true,
    );
    Get.put(ApiClient(), permanent: true);
  }
}
