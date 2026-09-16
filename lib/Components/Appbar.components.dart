import 'package:facial/Config/AppColors.config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> confirmarSaidaDialog({
  required bool temAlteracoes,
  required String mensagem,
  String title = 'Sair sem salvar',
}) async {
  if (!temAlteracoes) return true;

  final resultado = await Get.dialog<bool>(
    AlertDialog(
      backgroundColor: AppColors.lightGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(
        mensagem,
        style: const TextStyle(),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
          onPressed: () => Get.back(result: false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.lightGray,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Get.back(result: true),
          child: const Text('Sim, sair'),
        ),
      ],
    ),
  );

  return resultado ?? false;
}

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? proximaTela;
  final VoidCallback? onSalvar;
  final List<Widget>? acoesAdicionais;
  final PreferredSizeWidget? bottom; // Adicionado o parâmetro bottom

  const AppBarComponent({
    super.key,
    required this.title,
    this.proximaTela,
    this.onSalvar,
    this.acoesAdicionais,
    this.bottom, // Adicionado no construtor
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.lightGray,
      iconTheme: const IconThemeData(color: AppColors.darkBlue),
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.darkBlue,
        ),
      ),
      actions: [
        if (proximaTela != null)
          IconButton(
            icon: const Icon(Icons.pending_actions, color: AppColors.darkBlue),
            onPressed: () => Get.toNamed(proximaTela!),
          ),
        if (onSalvar != null)
          IconButton(
            icon: const Icon(Icons.save, color: AppColors.darkBlue),
            tooltip: 'Salvar',
            onPressed: onSalvar,
          ),
        if (acoesAdicionais != null) ...acoesAdicionais!,
      ],
      // Utiliza o bottom passado por parâmetro. Caso seja nulo, mantém a linha de borda padrão
      bottom:
          bottom ??
          PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: AppColors.border, height: 1.5),
          ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 1.0));
}
