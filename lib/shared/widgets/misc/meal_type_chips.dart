import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class MealTypeChips extends StatelessWidget {
  const MealTypeChips({
    super.key,
    required this.values,
    required this.selectedValue,
    required this.onSelected,
  });

  final List<String> values;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.sm,
      children: values
          .map((String value) {
            final bool isSelected = value == selectedValue;

            return Material(
              color: isSelected ? AppColors.primaryAccent : AppColors.surface,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryAccent
                      : AppColors.divider,
                ),
              ),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: () => onSelected(value),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.chipHorizontal,
                    vertical: AppSpacing.chipVertical,
                  ),
                  child: Text(
                    value,
                    style: isSelected
                        ? AppTextStyles.chipSelected
                        : AppTextStyles.chipUnselected,
                  ),
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
