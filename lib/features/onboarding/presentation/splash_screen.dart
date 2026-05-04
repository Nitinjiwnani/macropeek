import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    _splashTimer?.cancel();
    _splashTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) context.go(RouteNames.onboarding1);
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Center(child: const _SplashBrand(isLoading: true)),
        ),
      ),
    );
  }
}

class _SplashBrand extends StatelessWidget {
  const _SplashBrand({this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Icon(
            Icons.restaurant_menu,
            color: AppColors.surface,
            size: 40,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('MacroPeek AI', style: AppTextStyles.heading),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Effortless meal tracking',
          style: AppTextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
        if (isLoading) ...<Widget>[
          const SizedBox(height: AppSpacing.xl),
          const CircularProgressIndicator(strokeWidth: 2.5),
        ],
      ],
    );
  }
}
