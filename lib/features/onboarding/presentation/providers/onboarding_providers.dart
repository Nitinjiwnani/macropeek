import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String onboardingSeenKey = 'onboarding_seen';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

final hasSeenOnboardingProvider = FutureProvider<bool>((ref) async {
  final preferences = await ref.watch(sharedPreferencesProvider.future);
  return preferences.getBool(onboardingSeenKey) ?? false;
});

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, void>(OnboardingController.new);

class OnboardingController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> markSeen() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() async {
      final preferences = await ref.read(sharedPreferencesProvider.future);
      await preferences.setBool(onboardingSeenKey, true);
      ref.invalidate(hasSeenOnboardingProvider);
    });
  }

  Future<void> reset() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() async {
      final preferences = await ref.read(sharedPreferencesProvider.future);
      await preferences.remove(onboardingSeenKey);
      ref.invalidate(hasSeenOnboardingProvider);
    });
  }
}
