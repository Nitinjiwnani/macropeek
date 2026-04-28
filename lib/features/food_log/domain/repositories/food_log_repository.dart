import '../entities/food_log.dart';

abstract class FoodLogRepository {
  Future<void> addFoodLog(FoodLog log);
  Future<void> deleteFoodLog(String logId, String userId);
  Future<List<FoodLog>> getLogsForDate(String userId, DateTime date);
  Stream<List<FoodLog>> watchLogsForDate(String userId, DateTime date);
  Future<List<FoodLog>> getLogsForDateRange(
    String userId,
    DateTime start,
    DateTime end,
  );
}
