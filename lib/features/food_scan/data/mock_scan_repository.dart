import '../domain/entities/food_scan_result.dart';
import '../domain/repositories/food_scan_repository.dart';

class MockScanRepository implements FoodScanRepository {
  final Map<String, FoodScanResult> _cache = {};

  @override
  Future<FoodScanResult> scanFoodImage(String imagePath) async {
    // Simulates a 1.5s API call
    await Future.delayed(const Duration(milliseconds: 1500));
    return const FoodScanResult(
      foodName: 'Grilled Chicken Bowl',
      calories: 420.0,
      protein: 38.0,
      carbs: 42.0,
      fat: 12.0,
      servingSize: 1.0,
      servingUnit: 'bowl',
      confidence: 'high',
    );
  }

  @override
  FoodScanResult? getCachedResult(String foodName) => _cache[foodName];

  @override
  void cacheResult(String foodName, FoodScanResult result) {
    _cache[foodName] = result;
  }
}
