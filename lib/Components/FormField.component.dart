import 'package:facial/Config/AppColors.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormFieldComponent extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool enabled;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const FormFieldComponent({
    super.key,
    this.keyboardType,
    this.onChanged,
    this.maxLines,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.enabled = true,
    this.label, // Removido o 'required'
    this.hint,
    this.prefixIcon,
    this.sufixIcon,
    this.obscureText = false,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Exibe o Text e o SizedBox apenas se 'label' não for nulo nem vazio
        if (label != null && label!.isNotEmpty) ...[
          Text(
            label!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: enabled ? AppColors.darkBlue : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          onChanged: onChanged,
          initialValue: controller == null ? initialValue : null,
          canRequestFocus: !readOnly && enabled,
          maxLines: obscureText ? 1 : maxLines,
          keyboardType: keyboardType,
          readOnly: readOnly,
          enabled: enabled,
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background,
            alignLabelWithHint: true,
            hintText: hint,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            prefixIcon: prefixIcon != null
                ? UnconstrainedBox(
                    child: IconTheme(
                      data: IconThemeData(color: AppColors.textSecondary),
                      child: prefixIcon!,
                    ),
                  )
                : null,
            suffixIcon: sufixIcon,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border, width: 1.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
