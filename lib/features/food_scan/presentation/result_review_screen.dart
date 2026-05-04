import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/inputs/app_numeric_field.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/misc/ai_badge.dart';
import '../../food_log/domain/entities/meal_type.dart';
import '../../food_log/presentation/providers/food_log_providers.dart';
import '../domain/entities/food_scan_result.dart';
import 'providers/scan_providers.dart';

class ResultReviewScreen extends ConsumerStatefulWidget {
  const ResultReviewScreen({super.key});

  @override
  ConsumerState<ResultReviewScreen> createState() => _ResultReviewScreenState();
}

class _ResultReviewScreenState extends ConsumerState<ResultReviewScreen> {
  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _servingSizeController = TextEditingController();
  final _servingUnitController = TextEditingController();
  MealType _mealType = MealType.lunch;
  bool _hydrated = false;

  @override
  void dispose() {
    _foodNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _servingSizeController.dispose();
    _servingUnitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scan = ref.watch(scanResultProvider);
    final saveState = ref.watch(foodLogControllerProvider);

    ref.listen(foodLogControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (previous?.isLoading == true && context.mounted) {
            ref.read(scanResultProvider.notifier).clear();
            context.go(RouteNames.home);
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not save food log')),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Review Result')),
      body: SafeArea(
        child: scan.when(
          data: (result) {
            if (result == null) return const _NoResultState();
            _hydrate(result);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const AiBadge(),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: 'Food name',
                    controller: _foodNameController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppNumericField(
                    label: 'Calories',
                    unit: 'kcal',
                    controller: _caloriesController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AppNumericField(
                          label: 'Protein',
                          unit: 'g',
                          controller: _proteinController,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppNumericField(
                          label: 'Carbs',
                          unit: 'g',
                          controller: _carbsController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppNumericField(
                    label: 'Fat',
                    unit: 'g',
                    controller: _fatController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AppNumericField(
                          label: 'Serving',
                          unit: 'x',
                          controller: _servingSizeController,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppTextField(
                          label: 'Unit',
                          controller: _servingUnitController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Meal type', style: AppTextStyles.label),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: MealType.values
                        .map((mealType) {
                          return ChoiceChip(
                            label: Text(mealType.displayName),
                            selected: _mealType == mealType,
                            onSelected: (_) =>
                                setState(() => _mealType = mealType),
                          );
                        })
                        .toList(growable: false),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  PrimaryButton(
                    label: saveState.isLoading ? 'Saving...' : 'Save to log',
                    onPressed: saveState.isLoading ? null : () => _save(result),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('Scan result unavailable', style: AppTextStyles.body),
          ),
        ),
      ),
    );
  }

  void _hydrate(FoodScanResult result) {
    if (_hydrated) return;
    _foodNameController.text = result.foodName;
    _caloriesController.text = result.calories.toStringAsFixed(0);
    _proteinController.text = result.protein.toStringAsFixed(0);
    _carbsController.text = result.carbs.toStringAsFixed(0);
    _fatController.text = result.fat.toStringAsFixed(0);
    _servingSizeController.text = result.servingSize.toStringAsFixed(0);
    _servingUnitController.text = result.servingUnit;
    _hydrated = true;
  }

  Future<void> _save(FoodScanResult result) async {
    await ref
        .read(foodLogControllerProvider.notifier)
        .addLog(
          foodName: _foodNameController.text,
          calories:
              double.tryParse(_caloriesController.text) ?? result.calories,
          protein: double.tryParse(_proteinController.text) ?? result.protein,
          carbs: double.tryParse(_carbsController.text) ?? result.carbs,
          fat: double.tryParse(_fatController.text) ?? result.fat,
          servingSize:
              double.tryParse(_servingSizeController.text) ??
              result.servingSize,
          servingUnit: _servingUnitController.text,
          mealType: _mealType,
          source: 'api',
          imagePath: result.imagePath,
        );
  }
}

class _NoResultState extends StatelessWidget {
  const _NoResultState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.primaryAccent,
              size: 44,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No scan result yet', style: AppTextStyles.heading),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Scan a meal first, then review the nutrition here.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
