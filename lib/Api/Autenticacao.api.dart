import 'package:camera/camera.dart';
import 'package:facial/Config/ApiClinte.config.dart';
import 'package:get/get.dart';

class AutenticacaoApi {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> loginFacial(XFile foto) async {
    final formData = FormData({
      'foto': MultipartFile(foto.path, filename: 'reconhecimento.jpg'),
    });

    return await _apiClient.post('/auth/login/facial', formData);
  }
}
