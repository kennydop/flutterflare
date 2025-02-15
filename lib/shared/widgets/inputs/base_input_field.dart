import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/theme/app_text_styles.dart';

final inputFocusProvider =
    StateProvider.family<bool, String>((ref, id) => false);

class BaseInputField extends ConsumerStatefulWidget {
  final String fieldId;
  final String? label;
  final String? hint;
  final String? error;
  final bool readOnly;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;

  const BaseInputField({
    super.key,
    required this.fieldId,
    this.label,
    this.hint,
    this.error,
    this.readOnly = false,
    this.enabled = true,
    this.prefix,
    this.suffix,
    this.onTap,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.focusNode,
    this.decoration,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  BaseInputFieldState createState() => BaseInputFieldState();
}

class BaseInputFieldState extends ConsumerState<BaseInputField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.autofocus) {
      _focusNode.requestFocus();
    }

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    ref.read(inputFocusProvider(widget.fieldId).notifier).state =
        _focusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = ref.watch(inputFocusProvider(widget.fieldId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.label!,
              style: AppTextStyles.label.copyWith(
                color: isFocused
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          textCapitalization: widget.textCapitalization,
          decoration: (widget.decoration ?? const InputDecoration()).copyWith(
            hintText: widget.hint,
            errorText: widget.error,
            prefixIcon: widget.prefix,
            suffixIcon: widget.suffix,
          ),
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          validator: widget.validator,
          onTapOutside: (_) => _focusNode.unfocus(),
          onFieldSubmitted: (_) => _focusNode.unfocus(),
        ),
      ],
    );
  }
}
