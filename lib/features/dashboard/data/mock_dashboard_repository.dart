import '../domain/entities/daily_summary.dart';
import '../domain/entities/weekly_stats.dart';
import '../domain/repositories/dashboard_repository.dart';

class MockDashboardRepository implements DashboardRepository {
  static const double _calorieTarget = 2356.0;

  static DailySummary _summaryForDate(DateTime date) {
    final midnight = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = midnight == today;
    return DailySummary(
      date: midnight,
      caloriesConsumed: isToday ? 1005.0 : 0.0,
      calorieTarget: _calorieTarget,
      protein: isToday ? 35.3 : 0.0,
      carbs: isToday ? 174.0 : 0.0,
      fat: isToday ? 16.4 : 0.0,
    );
  }

  @override
  Future<DailySummary> getDailySummary(String userId, DateTime date) async =>
      _summaryForDate(date);

  @override
  Stream<DailySummary> watchDailySummary(String userId, DateTime date) =>
      Stream.value(_summaryForDate(date));

  @override
  Future<WeeklyStats> getWeeklyStats(String userId, DateTime endDate) async {
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    final start = end.subtract(const Duration(days: 6));

    final summaries = List.generate(
      7,
      (i) => _summaryForDate(start.add(Duration(days: i))),
    );

    return WeeklyStats(
      startDate: start,
      endDate: end,
      dailySummaries: summaries,
    );
  }
}
