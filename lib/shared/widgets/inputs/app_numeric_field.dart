import 'package:flutter/material.dart';

import 'app_text_field.dart';

class AppNumericField extends StatelessWidget {
  const AppNumericField({
    super.key,
    this.label,
    this.hintText,
    this.unit = 'kcal',
    this.controller,
    this.focusNode,
    this.errorText,
    this.onChanged,
    this.enabled = true,
  });

  final String? label;
  final String? hintText;
  final String unit;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hintText: hintText,
      controller: controller,
      focusNode: focusNode,
      errorText: errorText,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      suffixText: unit,
      enabled: enabled,
    );
  }
}
