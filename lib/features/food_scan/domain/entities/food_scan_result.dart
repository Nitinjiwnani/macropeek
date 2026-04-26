class FoodScanResult {
  const FoodScanResult({
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
    required this.servingUnit,
    required this.confidence,
    this.imagePath,
  });

  final String foodName;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double servingSize;
  final String servingUnit;
  final String confidence; // "high" | "medium" | "low"
  final String? imagePath;

  FoodScanResult copyWith({
    String? foodName,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? servingSize,
    String? servingUnit,
    String? confidence,
    String? imagePath,
  }) {
    return FoodScanResult(
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      confidence: confidence ?? this.confidence,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
