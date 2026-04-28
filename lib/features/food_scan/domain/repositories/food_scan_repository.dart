import '../entities/food_scan_result.dart';

abstract class FoodScanRepository {
  Future<FoodScanResult> scanFoodImage(String imagePath);
  FoodScanResult? getCachedResult(String foodName);
  void cacheResult(String foodName, FoodScanResult result);
}
