import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiClient extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://192.168.57.74:8000';

    httpClient.timeout = const Duration(seconds: 15);

    httpClient.addRequestModifier<dynamic>((request) async {
      debugPrint('=== REQUEST ===');
      debugPrint('Method: ${request.method}');
      debugPrint('URL: ${request.url}');
      debugPrint('Headers: ${request.headers}');

      return request;
    });

    httpClient.addResponseModifier((request, response) {
      if (response.hasError) {
        print('Erro API [${response.statusCode}]: ${response.statusText}');
      }
      return response;
    });

    super.onInit();
  }
}
