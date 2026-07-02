import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/theme/app_theme.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../widgets/onboarding_widgets.dart';

class Step0Welcome extends StatefulWidget {
  const Step0Welcome({super.key});

  @override
  State<Step0Welcome> createState() => _Step0WelcomeState();
}

class _Step0WelcomeState extends State<Step0Welcome> {
  final _nameController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final name = context.read<OnboardingBloc>().state.name;
      if (name.isNotEmpty) _nameController.text = name;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: context.screenPadding.copyWith(top: 32, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Decorative Arabic-style arc at top
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text('🌙', style: TextStyle(fontSize: 36)),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              const OnboardingStepHeader(
                title: 'Assalamu\nAlaykum 👋',
                subtitle:
                    'Let\'s build your personalized daily routine around your deen, health, and goals.',
              ),

              const SizedBox(height: AppSpacing.xl),

              // Name field
              const SectionLabel('YOUR NAME'),
              TextFormField(
                controller: _nameController,
                onChanged: (v) => context
                    .read<OnboardingBloc>()
                    .add(OnboardingNameChanged(v)),
                textCapitalization: TextCapitalization.words,
                style: AppTextStyles.bodyLarge,
                decoration: const InputDecoration(
                  hintText: 'e.g. Ahmed, Fatima…',
                  prefixIcon: Icon(Icons.person_outline,
                      color: AppColors.textHint, size: 20),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Gender selector
              const SectionLabel('I AM'),
              GenderSelector(
                selected: state.gender,
                onChanged: (g) => context
                    .read<OnboardingBloc>()
                    .add(OnboardingGenderChanged(g)),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Female-specific note
              if (state.gender == 'female')
                const InfoBanner(
                  text:
                      'We\'ll offer cycle-aware streak tracking so your spiritual streaks are never unfairly broken.',
                  icon: Icons.favorite_outline,
                  color: AppColors.maghrib,
                ),
            ],
          ),
        );
      },
    );
  }
}
