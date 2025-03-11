import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/validators/validators.dart';
import 'package:flutterflare/shared/widgets/inputs/base_input_field.dart';

class EmailInputField extends ConsumerWidget {
  final String fieldId;
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final String? error;
  final EmailInputFieldType? type;

  const EmailInputField({
    super.key,
    required this.fieldId,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.autofocus = false,
    this.error,
    this.type = EmailInputFieldType.Existing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseInputField(
      fieldId: fieldId,
      label: label ?? 'Email',
      hint: hint ?? 'Enter your email address',
      controller: controller,
      validator: validator ?? _defaultValidator,
      onChanged: onChanged,
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      autofocus: autofocus,
      error: error,
      textCapitalization: TextCapitalization.none,
    );
  }

  String? _defaultValidator(String? value) {
    if (type == EmailInputFieldType.New) {
      return FormValidator.validateEmail(value).error;
    } else {
      return FormValidator.validateRequired(value, label ?? 'Email').error;
    }
  }
}

enum EmailInputFieldType { New, Existing }
