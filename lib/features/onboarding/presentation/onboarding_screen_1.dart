import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return _OnboardingPage(
      icon: Icons.insights,
      title: 'Track daily progress',
      body: 'See calories and macros for the day in one calm, focused view.',
      actionLabel: 'Next',
      onAction: () => context.go(RouteNames.onboarding2),
      step: 1,
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    required this.step,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            children: <Widget>[
              const Spacer(),
              Container(
                width: 168,
                height: 168,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(icon, color: AppColors.primaryAccent, size: 72),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                title,
                style: AppTextStyles.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                body,
                style: AppTextStyles.subheading,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _StepDots(step: step),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: actionLabel, onPressed: onAction),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, (index) {
        final selected = index + 1 == step;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: selected ? 22 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryAccent : AppColors.divider,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
        );
      }),
    );
  }
}
