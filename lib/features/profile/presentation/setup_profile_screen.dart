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
import '../domain/entities/gender.dart';
import 'providers/profile_providers.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  ConsumerState<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  Gender _gender = Gender.male;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final setup = ref.read(setupFlowProvider);
    _nameController = TextEditingController(text: setup.name);
    _ageController = TextEditingController(text: setup.age?.toString() ?? '');
    _weightController = TextEditingController(
      text: setup.weightKg?.toStringAsFixed(0) ?? '',
    );
    _heightController = TextEditingController(
      text: setup.heightCm?.toStringAsFixed(0) ?? '',
    );
    _gender = setup.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About You')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Set up your profile', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'These details help calculate a practical daily calorie target.',
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: 'Name',
                hintText: 'Nitin',
                controller: _nameController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              AppNumericField(
                label: 'Age',
                hintText: '25',
                unit: 'years',
                controller: _ageController,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Gender', style: AppTextStyles.label),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                children: Gender.values
                    .map((gender) {
                      final isSelected = gender == _gender;
                      return ChoiceChip(
                        label: Text(gender.displayName),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _gender = gender),
                        selectedColor: AppColors.primaryAccent,
                        labelStyle: isSelected
                            ? AppTextStyles.chipSelected
                            : AppTextStyles.chipUnselected,
                        backgroundColor: AppColors.surface,
                        side: const BorderSide(color: AppColors.divider),
                      );
                    })
                    .toList(growable: false),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppNumericField(
                      label: 'Weight',
                      hintText: '75',
                      unit: 'kg',
                      controller: _weightController,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppNumericField(
                      label: 'Height',
                      hintText: '175',
                      unit: 'cm',
                      controller: _heightController,
                    ),
                  ),
                ],
              ),
              if (_errorMessage != null) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                Text(_errorMessage!, style: AppTextStyles.helperError),
              ],
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(label: 'Continue', onPressed: _continue),
            ],
          ),
        ),
      ),
    );
  }

  void _continue() {
    final age = int.tryParse(_ageController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    final height = double.tryParse(_heightController.text.trim());
    final name = _nameController.text.trim();

    if (name.isEmpty || age == null || weight == null || height == null) {
      setState(() {
        _errorMessage = 'Enter your name, age, weight, and height.';
      });
      return;
    }

    ref
        .read(setupFlowProvider.notifier)
        .updateProfileDetails(
          name: name,
          age: age,
          gender: _gender,
          weightKg: weight,
          heightCm: height,
        );
    context.go(RouteNames.setupGoal);
  }
}

extension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}
