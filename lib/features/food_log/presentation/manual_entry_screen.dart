import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/inputs/app_numeric_field.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../domain/entities/meal_type.dart';
import 'providers/food_log_providers.dart';

class ManualEntryScreen extends ConsumerStatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  ConsumerState<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends ConsumerState<ManualEntryScreen> {
  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _servingSizeController = TextEditingController(text: '1');
  final _servingUnitController = TextEditingController(text: 'serving');
  MealType _mealType = MealType.lunch;

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
    final controller = ref.watch(foodLogControllerProvider);

    ref.listen(foodLogControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (previous?.isLoading == true && context.mounted) {
            context.go(RouteNames.home);
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not save manual entry')),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Manual Entry')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Add food manually', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Use this when a photo is not available or you already know the nutrition.',
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(label: 'Food name', controller: _foodNameController),
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
                        onSelected: (_) => setState(() => _mealType = mealType),
                      );
                    })
                    .toList(growable: false),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: controller.isLoading ? 'Saving...' : 'Save entry',
                onPressed: controller.isLoading ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    await ref
        .read(foodLogControllerProvider.notifier)
        .addManualLog(
          foodName: _foodNameController.text,
          calories: double.tryParse(_caloriesController.text) ?? 0,
          protein: double.tryParse(_proteinController.text) ?? 0,
          carbs: double.tryParse(_carbsController.text) ?? 0,
          fat: double.tryParse(_fatController.text) ?? 0,
          servingSize: double.tryParse(_servingSizeController.text) ?? 1,
          servingUnit: _servingUnitController.text,
          mealType: _mealType,
        );
  }
}
