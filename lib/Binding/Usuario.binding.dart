import 'package:facial/Controller/Usuario.controller.dart';
import 'package:get/get.dart';

class Usuariobinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsuarioController>(() => UsuarioController());
  }
}
