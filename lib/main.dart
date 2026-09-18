import 'package:facial/AppRoutes.dart';
import 'package:facial/Binding/Home.binding.dart';
import 'package:facial/Binding/Login.binding.dart';
import 'package:facial/Binding/Usuario.binding.dart';
import 'package:facial/InitialBinding.dart';
import 'package:facial/Screens/Home.screen.dart';
import 'package:facial/Screens/Login.screen.dart';
import 'package:facial/Screens/Usuario.screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:google_fonts/google_fonts.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Facial());
}

class Facial extends StatelessWidget {
  const Facial({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      initialBinding: InitialBinding(),
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      getPages: [
        GetPage(
          name: AppRoutes.usuario,
          page: () => UsuarioScreen(),
          binding: UsuarioBinding(),
        ),
        GetPage(
          name: AppRoutes.login,
          page: () => LoginScreen(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: AppRoutes.home,
          page: () => HomeScreen(),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}
