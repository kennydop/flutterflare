import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/validators/form_validator.dart';
import 'package:flutterflare/shared/widgets/inputs/base_input_field.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';

final passwordVisibilityProvider =
    StateProvider.family<bool, String>((ref, id) => false);

class PasswordInputField extends ConsumerWidget {
  final String fieldId;
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final String? error;
  final PasswordInputFieldType? type;

  const PasswordInputField({
    super.key,
    required this.fieldId,
    this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.autofocus = false,
    this.error,
    this.type = PasswordInputFieldType.Existing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(passwordVisibilityProvider(fieldId));

    return BaseInputField(
      fieldId: fieldId,
      label: label,
      hint: hint,
      controller: controller,
      validator: validator ?? _defaultValidator,
      onChanged: onChanged,
      textInputAction: textInputAction,
      autofocus: autofocus,
      error: error,
      obscureText: !isVisible,
      suffix: IconButton(
        icon: Iconify(
          isVisible ? Ri.eye_close_line : Ri.eye_2_line,
          color: Theme.of(context).inputDecorationTheme.suffixIconColor,
        ),
        onPressed: () {
          ref.read(passwordVisibilityProvider(fieldId).notifier).state =
              !isVisible;
        },
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (type == PasswordInputFieldType.New) {
      return FormValidator.validatePassword(value).error;
    } else {
      return FormValidator.validateRequired(value, label ?? 'Password').error;
    }
  }
}

enum PasswordInputFieldType {
  New,
  Existing,
}
