import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_scan_repository.dart';
import '../../domain/entities/food_scan_result.dart';
import '../../domain/repositories/food_scan_repository.dart';

final foodScanRepositoryProvider = Provider<FoodScanRepository>((ref) {
  return MockScanRepository();
  // Batch 9: return GeminiScanRepository();
});

final scanResultProvider =
    AsyncNotifierProvider<FoodScanNotifier, FoodScanResult?>(
      FoodScanNotifier.new,
    );

final cachedScanResultProvider = Provider.family<FoodScanResult?, String>((
  ref,
  foodName,
) {
  return ref.watch(foodScanRepositoryProvider).getCachedResult(foodName);
});

class FoodScanNotifier extends AsyncNotifier<FoodScanResult?> {
  @override
  Future<FoodScanResult?> build() async => null;

  Future<void> scanImage(String imagePath) async {
    state = const AsyncLoading<FoodScanResult?>();
    state = await AsyncValue.guard<FoodScanResult?>(() async {
      final repository = ref.read(foodScanRepositoryProvider);
      final result = await repository.scanFoodImage(imagePath);
      final resultWithImage = result.copyWith(imagePath: imagePath);
      repository.cacheResult(resultWithImage.foodName, resultWithImage);
      return resultWithImage;
    });
  }

  void setResult(FoodScanResult result) {
    ref.read(foodScanRepositoryProvider).cacheResult(result.foodName, result);
    state = AsyncData<FoodScanResult?>(result);
  }

  void clear() {
    state = const AsyncData<FoodScanResult?>(null);
  }
}
