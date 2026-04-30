import '../domain/entities/gender.dart';
import '../domain/entities/goal_type.dart';
import '../domain/entities/user_profile.dart';
import '../domain/repositories/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  static final _mockProfile = UserProfile(
    userId: 'mock-user-001',
    name: 'Nitin',
    age: 25,
    gender: Gender.male,
    weightKg: 75.0,
    heightCm: 175.0,
    goal: GoalType.maintainWeight,
    dailyCalorieTarget: 2356.0,
    proteinTarget: 177.0,
    carbsTarget: 236.0,
    fatTarget: 78.0,
    isSetupComplete: true,
    createdAt: DateTime(2026, 4, 1),
    updatedAt: DateTime(2026, 4, 1),
  );

  UserProfile? _profile = _mockProfile;

  @override
  Future<UserProfile?> getProfile(String userId) async => _profile;

  @override
  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
  }

  @override
  Future<void> updateProfile(String userId, Map<String, dynamic> updates) async {
    if (_profile == null) return;
    _profile = _profile!.copyWith(
      name: updates['name'] as String? ?? _profile!.name,
      age: updates['age'] as int? ?? _profile!.age,
      weightKg: updates['weightKg'] as double? ?? _profile!.weightKg,
      heightCm: updates['heightCm'] as double? ?? _profile!.heightCm,
      dailyCalorieTarget:
          updates['dailyCalorieTarget'] as double? ?? _profile!.dailyCalorieTarget,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Stream<UserProfile?> watchProfile(String userId) =>
      Stream.value(_profile);
}
