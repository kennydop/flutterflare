import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/theme/app_colors.dart';
import 'package:flutterflare/core/theme/app_text_styles.dart';

class DropdownField<T> extends ConsumerStatefulWidget {
  final String fieldId;
  final String? label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? error;
  final bool enabled;

  const DropdownField({
    super.key,
    required this.fieldId,
    this.label,
    this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.error,
    this.enabled = true,
  });

  @override
  DropdownFieldState<T> createState() => DropdownFieldState<T>();
}

class DropdownFieldState<T> extends ConsumerState<DropdownField<T>> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _showCupertinoPicker() async {
    final items = widget.items
        .map((item) => Center(
              child: Text(
                widget.itemLabel(item),
                style: AppTextStyles.body1,
              ),
            ))
        .toList();

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32.0,
            scrollController: FixedExtentScrollController(
              initialItem: widget.value != null
                  ? widget.items.indexOf(widget.value as T)
                  : 0,
            ),
            onSelectedItemChanged: (int selectedIndex) {
              widget.onChanged(widget.items[selectedIndex]);
            },
            children: items,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.label!,
              style: AppTextStyles.body1.copyWith(
                color: _focusNode.hasFocus
                    ? AppColors.primaryLight
                    : AppColors.textHeading,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (Platform.isIOS)
          GestureDetector(
            onTap: widget.enabled ? _showCupertinoPicker : null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: widget.enabled ? AppColors.gray100 : AppColors.gray200,
                border: Border.all(
                  color: widget.error != null
                      ? AppColors.error
                      : _focusNode.hasFocus
                          ? AppColors.primaryLight
                          : AppColors.gray300,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.value != null
                        ? widget.itemLabel(widget.value as T)
                        : widget.hint ?? 'Select',
                    style: AppTextStyles.body1.copyWith(
                      color: widget.value != null
                          ? AppColors.textHeading
                          : AppColors.placeholder,
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_down,
                    size: 20,
                  ),
                ],
              ),
            ),
          )
        else
          DropdownButtonFormField<T>(
            focusNode: _focusNode,
            value: widget.value,
            items: widget.items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(widget.itemLabel(item)),
                  ),
                )
                .toList(),
            onChanged: widget.enabled ? widget.onChanged : null,
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: widget.error,
              enabled: widget.enabled,
            ),
          ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.error!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}
