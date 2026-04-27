import 'gender.dart';
import 'goal_type.dart';

class UserProfile {
  const UserProfile({
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    required this.goal,
    required this.dailyCalorieTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatTarget,
    required this.isSetupComplete,
    required this.createdAt,
    required this.updatedAt,
  });

  final String userId;
  final String name;
  final int age;
  final Gender gender;
  final double weightKg;
  final double heightCm;
  final GoalType goal;
  final double dailyCalorieTarget;
  final double proteinTarget;
  final double carbsTarget;
  final double fatTarget;
  final bool isSetupComplete;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile copyWith({
    String? userId,
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
    bool? isSetupComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
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
      isSetupComplete: isSetupComplete ?? this.isSetupComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
