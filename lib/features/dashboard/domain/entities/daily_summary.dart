class DailySummary {
  const DailySummary({
    required this.date,
    required this.caloriesConsumed,
    required this.calorieTarget,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final DateTime date;
  final double caloriesConsumed;
  final double calorieTarget;
  final double protein;
  final double carbs;
  final double fat;

  double get caloriesRemaining =>
      (calorieTarget - caloriesConsumed).clamp(0, calorieTarget);

  double get calorieProgress =>
      calorieTarget > 0 ? (caloriesConsumed / calorieTarget).clamp(0, 1) : 0;
}
