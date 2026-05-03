import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/calorie_calculator.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/mock_profile_repository.dart';
import '../../domain/entities/gender.dart';
import '../../domain/entities/goal_type.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return MockProfileRepository();
  // Batch 8: return FirestoreProfileRepository();
});

final userProfileProvider = FutureProvider.family<UserProfile?, String>((
  ref,
  userId,
) {
  return ref.watch(profileRepositoryProvider).getProfile(userId);
});

final watchedUserProfileProvider = StreamProvider.family<UserProfile?, String>((
  ref,
  userId,
) {
  return ref.watch(profileRepositoryProvider).watchProfile(userId);
});

final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream<UserProfile?>.value(null);

  return ref.watch(profileRepositoryProvider).watchProfile(user.uid);
});

final setupFlowProvider = NotifierProvider<SetupFlowNotifier, SetupFlowState>(
  SetupFlowNotifier.new,
);

class SetupFlowState {
  const SetupFlowState({
    this.name = '',
    this.age,
    this.gender = Gender.male,
    this.weightKg,
    this.heightCm,
    this.goal = GoalType.maintainWeight,
    this.dailyCalorieTarget,
    this.proteinTarget,
    this.carbsTarget,
    this.fatTarget,
    this.isSaving = false,
    this.errorMessage,
  });

  final String name;
  final int? age;
  final Gender gender;
  final double? weightKg;
  final double? heightCm;
  final GoalType goal;
  final double? dailyCalorieTarget;
  final double? proteinTarget;
  final double? carbsTarget;
  final double? fatTarget;
  final bool isSaving;
  final String? errorMessage;

  bool get hasProfileDetails =>
      name.trim().isNotEmpty &&
      age != null &&
      weightKg != null &&
      heightCm != null;

  bool get hasTargets =>
      dailyCalorieTarget != null &&
      proteinTarget != null &&
      carbsTarget != null &&
      fatTarget != null;

  SetupFlowState copyWith({
    String? name,
    int? age,
    Gender? gender,
    double? weightKg,
    double? heightCm,
    GoalType? goal,
    double? dailyCalorieTarget,
    double? proteinTarget,
    double? carbsTarget,
    double? fatTarget,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SetupFlowState(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      goal: goal ?? this.goal,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      carbsTarget: carbsTarget ?? this.carbsTarget,
      fatTarget: fatTarget ?? this.fatTarget,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SetupFlowNotifier extends Notifier<SetupFlowState> {
  @override
  SetupFlowState build() => const SetupFlowState();

  void updateProfileDetails({
    required String name,
    required int age,
    required Gender gender,
    required double weightKg,
    required double heightCm,
  }) {
    state = state.copyWith(
      name: name,
      age: age,
      gender: gender,
      weightKg: weightKg,
      heightCm: heightCm,
      clearError: true,
    );
  }

  void updateGoal(GoalType goal) {
    state = state.copyWith(goal: goal, clearError: true);
    calculateTargets();
  }

  void calculateTargets() {
    if (!state.hasProfileDetails) return;

    final targets = CalorieCalculator.calculate(
      weightKg: state.weightKg!,
      heightCm: state.heightCm!,
      age: state.age!,
      gender: state.gender,
      goal: state.goal,
    );

    state = state.copyWith(
      dailyCalorieTarget: targets.dailyCalorieTarget,
      proteinTarget: targets.proteinTarget,
      carbsTarget: targets.carbsTarget,
      fatTarget: targets.fatTarget,
      clearError: true,
    );
  }

  Future<void> saveProfile() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(errorMessage: 'Sign in before saving profile.');
      return;
    }

    if (!state.hasProfileDetails) {
      state = state.copyWith(errorMessage: 'Complete your profile details.');
      return;
    }

    if (!state.hasTargets) calculateTargets();

    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final now = DateTime.now();
      final profile = UserProfile(
        userId: user.uid,
        name: state.name.trim(),
        age: state.age!,
        gender: state.gender,
        weightKg: state.weightKg!,
        heightCm: state.heightCm!,
        goal: state.goal,
        dailyCalorieTarget: state.dailyCalorieTarget!,
        proteinTarget: state.proteinTarget!,
        carbsTarget: state.carbsTarget!,
        fatTarget: state.fatTarget!,
        isSetupComplete: true,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(profileRepositoryProvider).saveProfile(profile);
      ref.invalidate(currentUserProfileProvider);
      ref.invalidate(userProfileProvider(user.uid));
      state = state.copyWith(isSaving: false, clearError: true);
    } catch (error) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Could not save profile. Please try again.',
      );
    }
  }
}
