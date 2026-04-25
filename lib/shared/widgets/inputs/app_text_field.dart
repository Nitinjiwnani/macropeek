import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.focusNode,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.suffix,
    this.suffixText,
    this.enabled = true,
  });

  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final String? suffixText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null) ...<Widget>[
          Text(label!, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          style: AppTextStyles.inputText,
          cursorColor: AppColors.primaryAccent,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: AppTextStyles.inputHint,
            filled: true,
            fillColor: AppColors.inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.inputHorizontal,
              vertical: AppSpacing.inputVertical,
            ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: AppSpacing.inputHeight,
              minWidth: AppSpacing.inputHeight,
            ),
            suffixIcon: suffix,
            suffixText: suffixText,
            suffixStyle: AppTextStyles.bodySmall,
            enabledBorder: _border(
              hasError ? AppColors.error : AppColors.divider,
            ),
            focusedBorder: _border(
              hasError ? AppColors.error : AppColors.primaryAccent,
            ),
            disabledBorder: _border(AppColors.outline),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error),
          ),
        ),
        if (errorText != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xxs),
          Text(errorText!, style: AppTextStyles.helperError),
        ],
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
