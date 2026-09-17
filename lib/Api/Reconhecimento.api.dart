import 'package:camera/camera.dart';
import 'package:facial/Config/ApiClinte.config.dart';
import 'package:get/get.dart';

class ReconhecimentoApi {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> enviarFotoReconhecimento(XFile foto) async {
    final formData = FormData({
      'foto': MultipartFile(foto.path, filename: 'reconhecimento.jpg'),
    });

    return await _apiClient.post('/reconhecimento/', formData);
  }
}
