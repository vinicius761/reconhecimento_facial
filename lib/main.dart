import 'package:facial/Binding/Usuario.binding.dart';
import 'package:facial/InitialBinding.dart';
import 'package:facial/Screens/Usuario.screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/usuario',
      initialBinding: InitialBinding(),
      getPages: [
        GetPage(
          name: '/usuario',
          page: () => UsuarioScreen(),
          binding: Usuariobinding(),
        ),
      ],
    );
  }
}
