import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import 'providers/auth_providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAction = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (ref.read(currentUserProvider) != null && context.mounted) {
            context.go(RouteNames.setupProfile);
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google sign-in failed')),
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: AppColors.surface,
                  size: 42,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Welcome to MacroPeek AI', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Sign in to sync your food log and keep your nutrition history with you.',
                style: AppTextStyles.subheading,
              ),
              const Spacer(),
              PrimaryButton(
                label: authAction.isLoading
                    ? 'Signing in...'
                    : 'Continue with Google',
                leading: const Icon(
                  Icons.g_mobiledata,
                  color: AppColors.surface,
                ),
                onPressed: authAction.isLoading
                    ? null
                    : () => ref
                          .read(authControllerProvider.notifier)
                          .signInWithGoogle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
