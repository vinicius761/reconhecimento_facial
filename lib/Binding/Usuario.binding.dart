import 'package:facial/Controller/Usuario.controller.dart';
import 'package:get/get.dart';

class UsuarioBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UsuarioController());
  }
}
