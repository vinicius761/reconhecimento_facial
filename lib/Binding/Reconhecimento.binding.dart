import 'package:facial/Controller/Reconhecimento.controller.dart';
import 'package:get/get.dart';

class ReconhecimentoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReconhecimentoController>(() => ReconhecimentoController());
  }
}
