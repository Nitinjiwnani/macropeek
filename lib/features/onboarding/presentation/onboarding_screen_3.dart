import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import 'providers/onboarding_providers.dart';

class OnboardingScreen3 extends ConsumerWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingControllerProvider);

    ref.listen(onboardingControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not finish onboarding')),
          );
        },
      );
    });

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
                  Icons.photo_camera_outlined,
                  color: AppColors.primaryAccent,
                  size: 72,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Snap your meal', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Take a photo, confirm the nutrition, and keep your log moving.',
                style: AppTextStyles.subheading,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              const _StepDots(step: 3),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: controller.isLoading ? 'Starting...' : 'Get started',
                onPressed: controller.isLoading
                    ? null
                    : () async {
                        await ref
                            .read(onboardingControllerProvider.notifier)
                            .markSeen();
                        if (context.mounted) context.go(RouteNames.login);
                      },
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Back',
                onPressed: controller.isLoading
                    ? null
                    : () => context.go(RouteNames.onboarding2),
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
