import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../domain/entities/weekly_stats.dart';
import 'providers/dashboard_providers.dart';

class WeeklySummaryScreen extends ConsumerWidget {
  const WeeklySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyStats = ref.watch(weeklyStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Summary')),
      body: SafeArea(
        child: weeklyStats.when(
          data: (stats) => _WeeklyContent(stats: stats),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(
              'Could not load weekly summary',
              style: AppTextStyles.body,
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyContent extends StatelessWidget {
  const _WeeklyContent({required this.stats});

  final WeeklyStats stats;

  @override
  Widget build(BuildContext context) {
    final maxCalories = stats.dailySummaries.fold<double>(
      1,
      (max, day) => day.caloriesConsumed > max ? day.caloriesConsumed : max,
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: <Widget>[
        Text(
          '${DateFormat('MMM d').format(stats.startDate)} - ${DateFormat('MMM d').format(stats.endDate)}',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${stats.averageCalories.round()} kcal average',
          style: AppTextStyles.heading,
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            children: stats.dailySummaries
                .map((day) {
                  final fraction = day.caloriesConsumed / maxCalories;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 44,
                          child: Text(
                            DateFormat('E').format(day.date),
                            style: AppTextStyles.label,
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusPill,
                            ),
                            child: LinearProgressIndicator(
                              value: fraction.clamp(0, 1),
                              minHeight: 12,
                              backgroundColor: AppColors.macroTrack,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primaryAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        SizedBox(
                          width: 72,
                          child: Text(
                            '${day.caloriesConsumed.round()} kcal',
                            style: AppTextStyles.caption,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
