import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import 'providers/scan_providers.dart';

class CameraScreen extends ConsumerWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanResultProvider);

    ref.listen(scanResultProvider, (previous, next) {
      next.whenOrNull(
        data: (result) {
          if (result != null && context.mounted) {
            context.go(RouteNames.scanResult);
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not scan this image')),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Meal')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.photo_camera_outlined,
                        color: AppColors.surface,
                        size: 72,
                      ),
                      Positioned(
                        left: AppSpacing.lg,
                        right: AppSpacing.lg,
                        bottom: AppSpacing.lg,
                        child: Text(
                          'Camera preview placeholder',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.surface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: scanState.isLoading ? 'Analyzing...' : 'Scan mock meal',
                onPressed: scanState.isLoading
                    ? null
                    : () => ref
                          .read(scanResultProvider.notifier)
                          .scanImage('/mock/path/meal.jpg'),
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Add manually',
                onPressed: scanState.isLoading
                    ? null
                    : () => context.go(RouteNames.manualEntry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
