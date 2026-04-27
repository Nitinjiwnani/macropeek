import 'meal_type.dart';

class FoodLog {
  const FoodLog({
    required this.id,
    required this.userId,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
    required this.servingUnit,
    required this.mealType,
    required this.source,
    required this.date,
    required this.createdAt,
    this.imagePath,
  });

  final String id;
  final String userId;
  final String foodName;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double servingSize;
  final String servingUnit;
  final MealType mealType;
  final String source; // "api" | "manual"
  final String? imagePath; // nullable — manual entries have no image
  final DateTime date;   // always midnight — use toMidnight()
  final DateTime createdAt;

  FoodLog copyWith({
    String? id,
    String? userId,
    String? foodName,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? servingSize,
    String? servingUnit,
    MealType? mealType,
    String? source,
    String? imagePath,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return FoodLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      mealType: mealType ?? this.mealType,
      source: source ?? this.source,
      imagePath: imagePath ?? this.imagePath,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
