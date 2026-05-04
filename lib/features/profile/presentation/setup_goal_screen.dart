import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import '../domain/entities/goal_type.dart';
import 'providers/profile_providers.dart';

class SetupGoalScreen extends ConsumerWidget {
  const SetupGoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupFlowProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Goal')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Choose your direction', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'MacroPeek will adjust your target using a simple MVP formula.',
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: AppSpacing.xl),
              for (final goal in GoalType.values) ...<Widget>[
                _GoalTile(
                  goal: goal,
                  isSelected: setup.goal == goal,
                  onTap: () =>
                      ref.read(setupFlowProvider.notifier).updateGoal(goal),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              const Spacer(),
              PrimaryButton(
                label: 'Calculate target',
                onPressed: setup.hasProfileDetails
                    ? () {
                        ref.read(setupFlowProvider.notifier).calculateTargets();
                        context.go(RouteNames.setupTarget);
                      }
                    : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Back',
                onPressed: () => context.go(RouteNames.setupProfile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  final GoalType goal;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primaryLight : AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: isSelected ? AppColors.primaryAccent : AppColors.outline,
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(goal.icon, color: AppColors.primaryAccent),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(goal.title, style: AppTextStyles.body),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(goal.subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primaryAccent),
            ],
          ),
        ),
      ),
    );
  }
}

extension on GoalType {
  String get title {
    switch (this) {
      case GoalType.loseWeight:
        return 'Lose weight';
      case GoalType.maintainWeight:
        return 'Maintain weight';
      case GoalType.gainWeight:
        return 'Gain weight';
    }
  }

  String get subtitle {
    switch (this) {
      case GoalType.loseWeight:
        return 'Target sits 500 kcal below maintenance.';
      case GoalType.maintainWeight:
        return 'Target stays close to daily maintenance.';
      case GoalType.gainWeight:
        return 'Target sits 500 kcal above maintenance.';
    }
  }

  IconData get icon {
    switch (this) {
      case GoalType.loseWeight:
        return Icons.trending_down;
      case GoalType.maintainWeight:
        return Icons.balance;
      case GoalType.gainWeight:
        return Icons.trending_up;
    }
  }
}
