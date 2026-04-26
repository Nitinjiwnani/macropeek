import '../../features/profile/domain/entities/gender.dart';
import '../../features/profile/domain/entities/goal_type.dart';

class CalorieCalculator {
  const CalorieCalculator._();

  /// Mifflin-St Jeor BMR formula.
  static double calculateBmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    switch (gender) {
      case Gender.male:
        return base + 5;
      case Gender.female:
        return base - 161;
      case Gender.other:
        // Average of male and female
        return base - 78;
    }
  }

  /// TDEE — fixed at lightly active (1.375) for MVP.
  /// TODO(v2): add activity level selector.
  static double calculateTdee(double bmr) => bmr * 1.375;

  /// Daily calorie target after goal adjustment.
  static double calculateDailyTarget({
    required double tdee,
    required GoalType goal,
  }) {
    switch (goal) {
      case GoalType.loseWeight:
        return tdee - 500;
      case GoalType.maintainWeight:
        return tdee;
      case GoalType.gainWeight:
        return tdee + 500;
    }
  }

  /// Macro targets using 40/30/30 carbs/protein/fat split.
  static ({double protein, double carbs, double fat}) calculateMacros(
    double dailyTarget,
  ) {
    return (
      protein: (dailyTarget * 0.30) / 4,
      carbs: (dailyTarget * 0.40) / 4,
      fat: (dailyTarget * 0.30) / 9,
    );
  }

  /// Convenience method — runs full calculation and returns all targets.
  static ({
    double dailyCalorieTarget,
    double proteinTarget,
    double carbsTarget,
    double fatTarget,
  }) calculate({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
    required GoalType goal,
  }) {
    final bmr = calculateBmr(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
    );
    final tdee = calculateTdee(bmr);
    final dailyTarget = calculateDailyTarget(tdee: tdee, goal: goal);
    final macros = calculateMacros(dailyTarget);

    return (
      dailyCalorieTarget: dailyTarget,
      proteinTarget: macros.protein,
      carbsTarget: macros.carbs,
      fatTarget: macros.fat,
    );
  }
}
