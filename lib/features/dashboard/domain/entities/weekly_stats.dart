import 'daily_summary.dart';

class WeeklyStats {
  const WeeklyStats({
    required this.startDate,
    required this.endDate,
    required this.dailySummaries,
  });

  final DateTime startDate;
  final DateTime endDate;
  final List<DailySummary> dailySummaries;

  double get averageCalories {
    if (dailySummaries.isEmpty) return 0;
    final total = dailySummaries.fold<double>(
      0,
      (sum, day) => sum + day.caloriesConsumed,
    );
    return total / dailySummaries.length;
  }
}
