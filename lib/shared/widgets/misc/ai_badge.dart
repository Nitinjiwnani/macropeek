import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class AiBadge extends StatelessWidget {
  const AiBadge({
    super.key,
    this.label = 'AI Estimated',
    this.icon = Icons.auto_awesome,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.badgeHorizontal,
        vertical: AppSpacing.badgeVertical,
      ),
      decoration: BoxDecoration(
        color: AppColors.badgeBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 12.83, color: AppColors.primaryAccent),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTextStyles.badge),
        ],
      ),
    );
  }
}
