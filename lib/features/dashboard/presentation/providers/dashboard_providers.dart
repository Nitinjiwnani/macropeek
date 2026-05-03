import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_extensions.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/mock_dashboard_repository.dart';
import '../../domain/entities/daily_summary.dart';
import '../../domain/entities/weekly_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return MockDashboardRepository();
  // Batch 8: return FirestoreDashboardRepository();
});

final dailySummaryProvider = FutureProvider.family<DailySummary, DateTime>((
  ref,
  date,
) {
  final user = ref.watch(currentUserProvider);
  final midnight = date.toMidnight();

  if (user == null) {
    return Future<DailySummary>.value(_emptySummary(midnight));
  }

  return ref
      .watch(dashboardRepositoryProvider)
      .getDailySummary(user.uid, midnight);
});

final watchedDailySummaryProvider =
    StreamProvider.family<DailySummary, DateTime>((ref, date) {
      final user = ref.watch(currentUserProvider);
      final midnight = date.toMidnight();

      if (user == null) {
        return Stream<DailySummary>.value(_emptySummary(midnight));
      }

      return ref
          .watch(dashboardRepositoryProvider)
          .watchDailySummary(user.uid, midnight);
    });

final weeklyStatsProvider = FutureProvider<WeeklyStats>((ref) {
  return ref.watch(weeklyStatsForEndDateProvider(DateTime.now()).future);
});

final weeklyStatsForEndDateProvider =
    FutureProvider.family<WeeklyStats, DateTime>((ref, endDate) {
      final user = ref.watch(currentUserProvider);
      final end = endDate.toMidnight();

      if (user == null) {
        return Future<WeeklyStats>.value(_emptyWeek(end));
      }

      return ref
          .watch(dashboardRepositoryProvider)
          .getWeeklyStats(user.uid, end);
    });

DailySummary _emptySummary(DateTime date) {
  return DailySummary(
    date: date,
    caloriesConsumed: 0,
    calorieTarget: 0,
    protein: 0,
    carbs: 0,
    fat: 0,
  );
}

WeeklyStats _emptyWeek(DateTime endDate) {
  final end = endDate.toMidnight();
  final start = end.subtract(const Duration(days: 6));
  return WeeklyStats(
    startDate: start,
    endDate: end,
    dailySummaries: List<DailySummary>.generate(
      7,
      (index) => _emptySummary(start.add(Duration(days: index))),
      growable: false,
    ),
  );
}
