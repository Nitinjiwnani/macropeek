import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/cards/macro_stat_card.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../food_log/domain/entities/food_log.dart';
import '../../food_log/domain/entities/meal_type.dart';
import '../../food_log/presentation/providers/food_log_providers.dart';
import '../domain/entities/daily_summary.dart';
import 'providers/dashboard_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedLogDateProvider);
    final summary = ref.watch(watchedDailySummaryProvider(selectedDate));
    final logs = ref.watch(foodLogsForTodayProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MacroPeek AI'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Weekly summary',
            onPressed: () => context.go(RouteNames.weekly),
            icon: const Icon(Icons.bar_chart),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(watchedDailySummaryProvider(selectedDate));
            ref.invalidate(foodLogsForTodayProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            children: <Widget>[
              Text(
                DateFormat('EEEE, MMM d').format(selectedDate),
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text('Today', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.lg),
              summary.when(
                data: (data) => _SummaryCard(summary: data),
                loading: () => const _LoadingBlock(height: 164),
                error: (error, stackTrace) => _ErrorBlock(
                  message: 'Could not load daily summary',
                  onRetry: () =>
                      ref.invalidate(watchedDailySummaryProvider(selectedDate)),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              logs.when(
                data: (items) => _MealSections(logs: items),
                loading: () => const _LoadingBlock(height: 260),
                error: (error, stackTrace) => _ErrorBlock(
                  message: 'Could not load food logs',
                  onRetry: () => ref.invalidate(foodLogsForTodayProvider),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(RouteNames.scan),
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: AppColors.surface,
        icon: const Icon(Icons.photo_camera_outlined),
        label: const Text('Scan'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            0,
            AppSpacing.pagePadding,
            AppSpacing.md,
          ),
          child: OutlinedButton.icon(
            onPressed: () => context.go(RouteNames.manualEntry),
            icon: const Icon(Icons.edit_note),
            label: const Text('Add manually'),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '${summary.caloriesConsumed.round()}',
                style: AppTextStyles.display,
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text(
                  'of ${summary.calorieTarget.round()} kcal',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            child: LinearProgressIndicator(
              value: summary.calorieProgress,
              minHeight: 8,
              backgroundColor: AppColors.macroTrack,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryAccent,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: MacroStatCard(
                  label: 'Protein',
                  value: summary.protein.round().toString(),
                  unit: 'g',
                  progress: summary.protein / 177,
                  accentColor: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: MacroStatCard(
                  label: 'Carbs',
                  value: summary.carbs.round().toString(),
                  unit: 'g',
                  progress: summary.carbs / 236,
                  accentColor: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          MacroStatCard(
            label: 'Fat',
            value: summary.fat.round().toString(),
            unit: 'g',
            progress: summary.fat / 78,
            accentColor: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }
}

class _MealSections extends StatelessWidget {
  const _MealSections({required this.logs});

  final List<FoodLog> logs;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const _EmptyState(
        title: 'No meals yet',
        message: 'Scan a meal or add one manually to start today’s log.',
      );
    }

    return Column(
      children: MealType.values
          .map((mealType) {
            final mealLogs = logs
                .where((log) => log.mealType == mealType)
                .toList(growable: false);
            if (mealLogs.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _MealSection(mealType: mealType, logs: mealLogs),
            );
          })
          .toList(growable: false),
    );
  }
}

class _MealSection extends StatelessWidget {
  const _MealSection({required this.mealType, required this.logs});

  final MealType mealType;
  final List<FoodLog> logs;

  @override
  Widget build(BuildContext context) {
    final calories = logs.fold<double>(0, (sum, log) => sum + log.calories);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(mealType.displayName, style: AppTextStyles.body),
              ),
              Text('${calories.round()} kcal', style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final log in logs) _FoodLogRow(log: log),
        ],
      ),
    );
  }
}

class _FoodLogRow extends StatelessWidget {
  const _FoodLogRow({required this.log});

  final FoodLog log;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              log.source == 'api' ? Icons.auto_awesome : Icons.edit_note,
              color: AppColors.primaryAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(log.foodName, style: AppTextStyles.body),
                Text(
                  '${log.servingSize.toStringAsFixed(log.servingSize.truncateToDouble() == log.servingSize ? 0 : 1)} ${log.servingUnit}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text('${log.calories.round()} kcal', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outline),
      ),
      child: const CircularProgressIndicator(strokeWidth: 2.5),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(message, style: AppTextStyles.bodySmall)),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.restaurant,
            color: AppColors.primaryAccent,
            size: 32,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
