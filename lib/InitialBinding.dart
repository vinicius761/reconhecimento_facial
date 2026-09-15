import 'package:facial/Controller/FaceDetector.controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceDetectorController>(() => FaceDetectorController());
  }
}
