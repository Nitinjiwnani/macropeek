import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leading,
    this.expand = true,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final bool expand;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return SizedBox(
      width: expand ? double.infinity : width,
      height: AppSpacing.buttonHeight,
      child: Material(
        color: isEnabled ? AppColors.primaryAccent : AppColors.disabledSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.buttonHorizontal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  leading!,
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  label,
                  style: AppTextStyles.buttonPrimary.copyWith(
                    color: isEnabled
                        ? AppColors.surface
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
