import 'package:facial/Config/AppColors.config.dart';
import 'package:facial/Controller/Home.controller.dart';
import 'package:facial/Controller/Login.controller.dart';
import 'package:facial/Utils/ObterInicias.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    LoginController loginController = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => CircleAvatar(
                                radius: 26,
                                backgroundColor: AppColors.lightGray,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: AppColors.primaryBlue,
                                  child: Text(
                                    obterIniciais(
                                      loginController.usuario.value?.nome ?? '',
                                    ),
                                    style: const TextStyle(
                                      color: AppColors.lightGray,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(
                                  () => IconButton(
                                    onPressed: controller.setIsVisivel,
                                    icon: Icon(
                                      controller.isVisivel.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColors.lightGray,
                                      size: 22,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 12),
                                Icon(
                                  Icons.help_outline,
                                  color: AppColors.lightGray,
                                  size: 22,
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  Icons.email,
                                  color: AppColors.lightGray,
                                  size: 22,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => Text(
                            "Olá, ${loginController.usuario.value?.nome ?? 'Usuário'}",
                            style: const TextStyle(
                              color: AppColors.lightGray,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 1, color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saldo de Horas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          SizedBox(height: 8),
                          Obx(
                            () => Text(
                              controller.isVisivel.value
                                  ? '08:00 hrs'
                                  : '••••••••',
                              style: const TextStyle(
                                fontSize: 24,
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 70),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: controller.menuItem.map((item) {
                    return Tooltip(
                      message: item.descricao,
                      child: Container(
                        margin: const EdgeInsets.only(right: 12, bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          border: Border.all(width: 1, color: AppColors.border),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: InkWell(
                          onTap: () => Get.toNamed(item.rota),
                          borderRadius: BorderRadius.circular(100),
                          child: Icon(
                            item.iconData,
                            color: AppColors.primaryBlue,
                            size: 24,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // const SizedBox(height: 10),
              ...controller.pontos.map(
                (item) => Obx(
                  () => Container(
                    margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    padding: EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      border: Border.all(width: 1, color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.isVisivel.value
                              ? "${item.dataFormatada.toString()} ${item.horaFormatada.toString()}"
                              : '••••••••',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          controller.isVisivel.value
                              ? "${item.tipo.toString()} "
                              : '••••••••',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
