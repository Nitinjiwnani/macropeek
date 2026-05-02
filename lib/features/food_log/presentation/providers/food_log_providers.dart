import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_extensions.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/mock_food_log_repository.dart';
import '../../domain/entities/food_log.dart';
import '../../domain/entities/meal_type.dart';
import '../../domain/repositories/food_log_repository.dart';

final foodLogRepositoryProvider = Provider<FoodLogRepository>((ref) {
  return MockFoodLogRepository();
  // Batch 8: return FirestoreFoodLogRepository();
});

final selectedLogDateProvider =
    NotifierProvider<SelectedLogDateNotifier, DateTime>(
      SelectedLogDateNotifier.new,
    );

class SelectedLogDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now().toMidnight();

  void select(DateTime date) {
    state = date.toMidnight();
  }

  void selectToday() {
    state = DateTime.now().toMidnight();
  }
}

final foodLogsForDateProvider = StreamProvider.family<List<FoodLog>, DateTime>((
  ref,
  date,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream<List<FoodLog>>.value(const <FoodLog>[]);

  return ref
      .watch(foodLogRepositoryProvider)
      .watchLogsForDate(user.uid, date.toMidnight());
});

final foodLogsForTodayProvider = StreamProvider<List<FoodLog>>((ref) {
  final user = ref.watch(currentUserProvider);
  final selectedDate = ref.watch(selectedLogDateProvider);
  if (user == null) return Stream<List<FoodLog>>.value(const <FoodLog>[]);

  return ref
      .watch(foodLogRepositoryProvider)
      .watchLogsForDate(user.uid, selectedDate);
});

final foodLogControllerProvider =
    AsyncNotifierProvider<FoodLogController, void>(FoodLogController.new);

class FoodLogController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addManualLog({
    required String foodName,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required double servingSize,
    required String servingUnit,
    required MealType mealType,
    DateTime? date,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      state = AsyncError<void>(
        StateError('Sign in before adding food logs.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() async {
      final now = DateTime.now();
      final selectedDate = ref.read(selectedLogDateProvider);
      final logDate = (date ?? selectedDate).toMidnight();
      final log = FoodLog(
        id: 'manual-${now.microsecondsSinceEpoch}',
        userId: user.uid,
        foodName: foodName.trim(),
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        servingSize: servingSize,
        servingUnit: servingUnit.trim(),
        mealType: mealType,
        source: 'manual',
        date: logDate,
        createdAt: now,
      );

      await ref.read(foodLogRepositoryProvider).addFoodLog(log);
      ref.invalidate(foodLogsForDateProvider(logDate));
      ref.invalidate(foodLogsForTodayProvider);
    });
  }

  Future<void> deleteLog(FoodLog log) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() async {
      await ref
          .read(foodLogRepositoryProvider)
          .deleteFoodLog(log.id, log.userId);
      ref.invalidate(foodLogsForDateProvider(log.date));
      ref.invalidate(foodLogsForTodayProvider);
    });
  }
}
