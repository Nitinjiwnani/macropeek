import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/dashboard/presentation/home_screen.dart';
import '../../features/dashboard/presentation/weekly_summary_screen.dart';
import '../../features/food_log/presentation/manual_entry_screen.dart';
import '../../features/food_scan/presentation/camera_screen.dart';
import '../../features/food_scan/presentation/result_review_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen_1.dart';
import '../../features/onboarding/presentation/onboarding_screen_2.dart';
import '../../features/onboarding/presentation/onboarding_screen_3.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/profile/presentation/setup_goal_screen.dart';
import '../../features/profile/presentation/setup_profile_screen.dart';
import '../../features/profile/presentation/setup_target_screen.dart';
import '../../features/profile/presentation/welcome_screen.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.read(authRepositoryProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _GoRouterRefreshStream(authRepo.authStateChanges),
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final location = state.matchedLocation;

      if (authState.isLoading) return RouteNames.splash;

      final user = authState.asData?.value;

      final isPublicRoute = location == RouteNames.splash ||
          location == RouteNames.login ||
          location == RouteNames.onboarding1 ||
          location == RouteNames.onboarding2 ||
          location == RouteNames.onboarding3;

      if (user == null) {
        return isPublicRoute ? null : RouteNames.login;
      }

      // Logged in — skip public screens
      // TODO(Batch 6): check profile completeness → redirect to /setup/profile
      if (isPublicRoute) return RouteNames.home;

      return null;
    },
    routes: [
      GoRoute(path: RouteNames.splash,       builder: (_, __) => const SplashScreen()),
      GoRoute(path: RouteNames.onboarding1,  builder: (_, __) => const OnboardingScreen1()),
      GoRoute(path: RouteNames.onboarding2,  builder: (_, __) => const OnboardingScreen2()),
      GoRoute(path: RouteNames.onboarding3,  builder: (_, __) => const OnboardingScreen3()),
      GoRoute(path: RouteNames.login,        builder: (_, __) => const LoginScreen()),
      GoRoute(path: RouteNames.setupProfile, builder: (_, __) => const SetupProfileScreen()),
      GoRoute(path: RouteNames.setupGoal,    builder: (_, __) => const SetupGoalScreen()),
      GoRoute(path: RouteNames.setupTarget,  builder: (_, __) => const SetupTargetScreen()),
      GoRoute(path: RouteNames.welcome,      builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: RouteNames.home,         builder: (_, __) => const HomeScreen()),
      GoRoute(path: RouteNames.scan,         builder: (_, __) => const CameraScreen()),
      GoRoute(path: RouteNames.scanResult,   builder: (_, __) => const ResultReviewScreen()),
      GoRoute(path: RouteNames.manualEntry,  builder: (_, __) => const ManualEntryScreen()),
      GoRoute(path: RouteNames.weekly,       builder: (_, __) => const WeeklySummaryScreen()),
    ],
  );
});

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
