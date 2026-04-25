import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class MacroStatCard extends StatelessWidget {
  const MacroStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.progress,
    required this.accentColor,
  });

  final String label;
  final String value;
  final String unit;
  final double progress;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outline),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label.toUpperCase(), style: AppTextStyles.macroLabel),
          const SizedBox(height: AppSpacing.sm),
          RichText(
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(text: value, style: AppTextStyles.macroValue),
                const WidgetSpan(child: SizedBox(width: AppSpacing.xs)),
                TextSpan(text: unit, style: AppTextStyles.macroUnit),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: AppSpacing.progressHeight,
              backgroundColor: AppColors.macroTrack,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
        ],
      ),
    );
  }
}
