import '../entities/daily_summary.dart';
import '../entities/weekly_stats.dart';

abstract class DashboardRepository {
  Future<DailySummary> getDailySummary(String userId, DateTime date);
  Future<WeeklyStats> getWeeklyStats(String userId, DateTime endDate);
  Stream<DailySummary> watchDailySummary(String userId, DateTime date);
}
