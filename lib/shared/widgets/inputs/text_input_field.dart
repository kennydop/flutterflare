import 'package:flutter/material.dart';
import 'package:flutterflare/shared/widgets/inputs/base_input_field.dart';

class TextInputField extends StatelessWidget {
  final String fieldId;
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool readOnly;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final String? error;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? maxLength;

  const TextInputField({
    super.key,
    required this.fieldId,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.error,
    this.prefix,
    this.suffix,
    this.onTap,
    this.maxLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return BaseInputField(
      fieldId: fieldId,
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofocus: autofocus,
      error: error,
      prefix: prefix,
      suffix: suffix,
      onTap: onTap,
      maxLines: maxLines,
      maxLength: maxLength,
    );
  }
}
