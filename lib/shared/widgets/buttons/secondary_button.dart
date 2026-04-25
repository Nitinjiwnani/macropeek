import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expand = true,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return SizedBox(
      width: expand ? double.infinity : width,
      height: AppSpacing.buttonHeight,
      child: Material(
        color: isEnabled ? AppColors.primaryLight : AppColors.disabledSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.buttonHorizontal,
            ),
            child: Center(
              child: Text(
                label,
                style: AppTextStyles.buttonSecondary.copyWith(
                  color: isEnabled
                      ? AppColors.primaryAccent
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
