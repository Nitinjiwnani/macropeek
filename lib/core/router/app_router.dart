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

      final isPublicRoute =
          location == RouteNames.splash ||
          location == RouteNames.login ||
          location == RouteNames.onboarding1 ||
          location == RouteNames.onboarding2 ||
          location == RouteNames.onboarding3;

      if (authState.isLoading) {
        return isPublicRoute ? null : RouteNames.splash;
      }

      final user = authState.asData?.value;

      if (user == null) {
        return isPublicRoute ? null : RouteNames.login;
      }

      // Logged in — skip public screens
      // TODO(Batch 6): check profile completeness → redirect to /setup/profile
      if (isPublicRoute) return RouteNames.home;

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding1,
        builder: (context, state) => const OnboardingScreen1(),
      ),
      GoRoute(
        path: RouteNames.onboarding2,
        builder: (context, state) => const OnboardingScreen2(),
      ),
      GoRoute(
        path: RouteNames.onboarding3,
        builder: (context, state) => const OnboardingScreen3(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.setupProfile,
        builder: (context, state) => const SetupProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.setupGoal,
        builder: (context, state) => const SetupGoalScreen(),
      ),
      GoRoute(
        path: RouteNames.setupTarget,
        builder: (context, state) => const SetupTargetScreen(),
      ),
      GoRoute(
        path: RouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.scan,
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: RouteNames.scanResult,
        builder: (context, state) => const ResultReviewScreen(),
      ),
      GoRoute(
        path: RouteNames.manualEntry,
        builder: (context, state) => const ManualEntryScreen(),
      ),
      GoRoute(
        path: RouteNames.weekly,
        builder: (context, state) => const WeeklySummaryScreen(),
      ),
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
