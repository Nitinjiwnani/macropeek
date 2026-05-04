import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

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
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primaryAccent,
                  size: 72,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Review AI estimates',
                style: AppTextStyles.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'MacroPeek gives you a starting point, and you stay in control before saving.',
                style: AppTextStyles.subheading,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              const _StepDots(step: 2),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: 'Next',
                onPressed: () => context.go(RouteNames.onboarding3),
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Back',
                onPressed: () => context.go(RouteNames.onboarding1),
              ),
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
