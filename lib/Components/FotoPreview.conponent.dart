import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:facial/Config/AppColors.config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FotoPreviewWidget extends StatelessWidget {
  final Rxn<XFile> fotoRx;
  final Future<XFile?> Function() onTirarFoto;
  final String labelBotaoTirar;
  final String labelBotaoTrocar;
  final double alturaPreview;
  final double larguraPreview;

  const FotoPreviewWidget({
    super.key,
    required this.fotoRx,
    required this.onTirarFoto,
    this.labelBotaoTirar = 'Registrar foto',
    this.labelBotaoTrocar = 'Tirar outra foto',
    this.alturaPreview = 250,
    this.larguraPreview = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final XFile? foto = fotoRx.value;

      if (foto == null) {
        return SizedBox(
          child: DottedBorder(
            color: AppColors.border,
            strokeWidth: 2,
            dashPattern: const [6, 4],
            borderType: BorderType.RRect,
            radius: const Radius.circular(8),
            child: InkWell(
              splashColor: AppColors.lightGray,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () async {
                final XFile? fotoCapturada = await onTirarFoto();
                if (fotoCapturada != null) {
                  fotoRx.value = fotoCapturada;
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      color: AppColors.textSecondary,
                    ),
                    Text(
                      labelBotaoTirar,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: alturaPreview,
              width: larguraPreview,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.file(File(foto.path), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                    side: const BorderSide(
                      color: AppColors.primaryBlue,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    final XFile? novaFoto = await onTirarFoto();
                    if (novaFoto != null) {
                      fotoRx.value = novaFoto;
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(labelBotaoTrocar),
                ),
              ),
              const SizedBox(width: 8),
              // Botão para deletar a foto atual
              IconButton(
                onPressed: () => fotoRx.value = null,
                icon: const Icon(Icons.delete, color: AppColors.red),
                tooltip: 'Remover foto',
              ),
            ],
          ),
        ],
      );
    });
  }
}
