import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import '../../../shared/widgets/cards/macro_stat_card.dart';
import 'providers/profile_providers.dart';

class SetupTargetScreen extends ConsumerWidget {
  const SetupTargetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupFlowProvider);

    ref.listen(setupFlowProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Your Target')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Daily nutrition target', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'You can edit this later when real profile settings are added.',
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      '${setup.dailyCalorieTarget?.round() ?? 0}',
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                    Text(
                      'kcal per day',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MacroStatCard(
                      label: 'Protein',
                      value: '${setup.proteinTarget?.round() ?? 0}',
                      unit: 'g',
                      progress: 1,
                      accentColor: const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: MacroStatCard(
                      label: 'Carbs',
                      value: '${setup.carbsTarget?.round() ?? 0}',
                      unit: 'g',
                      progress: 1,
                      accentColor: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              MacroStatCard(
                label: 'Fat',
                value: '${setup.fatTarget?.round() ?? 0}',
                unit: 'g',
                progress: 1,
                accentColor: const Color(0xFFEF4444),
              ),
              const Spacer(),
              PrimaryButton(
                label: setup.isSaving ? 'Saving...' : 'Save profile',
                onPressed: setup.isSaving
                    ? null
                    : () async {
                        await ref
                            .read(setupFlowProvider.notifier)
                            .saveProfile();
                        if (context.mounted) context.go(RouteNames.welcome);
                      },
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Back',
                onPressed: setup.isSaving
                    ? null
                    : () => context.go(RouteNames.setupGoal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
