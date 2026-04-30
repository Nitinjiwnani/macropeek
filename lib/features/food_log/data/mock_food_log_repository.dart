import '../domain/entities/food_log.dart';
import '../domain/entities/meal_type.dart';
import '../domain/repositories/food_log_repository.dart';

class MockFoodLogRepository implements FoodLogRepository {
  final List<FoodLog> _logs = [
    FoodLog(
      id: 'log-001',
      userId: 'mock-user-001',
      foodName: 'Masala Oats',
      calories: 320.0,
      protein: 12.0,
      carbs: 52.0,
      fat: 6.0,
      servingSize: 1.0,
      servingUnit: 'bowl',
      mealType: MealType.breakfast,
      source: 'manual',
      date: DateTime(2026, 4, 30),
      createdAt: DateTime(2026, 4, 30, 8, 15),
    ),
    FoodLog(
      id: 'log-002',
      userId: 'mock-user-001',
      foodName: 'Dal Tadka with Rice',
      calories: 580.0,
      protein: 22.0,
      carbs: 95.0,
      fat: 10.0,
      servingSize: 1.0,
      servingUnit: 'plate',
      mealType: MealType.lunch,
      source: 'api',
      date: DateTime(2026, 4, 30),
      createdAt: DateTime(2026, 4, 30, 13, 0),
    ),
    FoodLog(
      id: 'log-003',
      userId: 'mock-user-001',
      foodName: 'Banana',
      calories: 105.0,
      protein: 1.3,
      carbs: 27.0,
      fat: 0.4,
      servingSize: 1.0,
      servingUnit: 'piece',
      mealType: MealType.snack,
      source: 'manual',
      date: DateTime(2026, 4, 30),
      createdAt: DateTime(2026, 4, 30, 16, 30),
    ),
  ];

  @override
  Future<void> addFoodLog(FoodLog log) async {
    _logs.add(log);
  }

  @override
  Future<void> deleteFoodLog(String logId, String userId) async {
    _logs.removeWhere((log) => log.id == logId && log.userId == userId);
  }

  @override
  Future<List<FoodLog>> getLogsForDate(String userId, DateTime date) async {
    final midnight = DateTime(date.year, date.month, date.day);
    return _logs
        .where((log) => log.userId == userId && log.date == midnight)
        .toList();
  }

  @override
  Stream<List<FoodLog>> watchLogsForDate(String userId, DateTime date) {
    final midnight = DateTime(date.year, date.month, date.day);
    final filtered = _logs
        .where((log) => log.userId == userId && log.date == midnight)
        .toList();
    return Stream.value(filtered);
  }

  @override
  Future<List<FoodLog>> getLogsForDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final startMidnight = DateTime(start.year, start.month, start.day);
    final endMidnight = DateTime(end.year, end.month, end.day);
    return _logs
        .where(
          (log) =>
              log.userId == userId &&
              !log.date.isBefore(startMidnight) &&
              !log.date.isAfter(endMidnight),
        )
        .toList();
  }
}
