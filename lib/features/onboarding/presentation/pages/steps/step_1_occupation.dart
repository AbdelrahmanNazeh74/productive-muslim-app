import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/theme/app_theme.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../widgets/onboarding_widgets.dart';

class Step1Occupation extends StatelessWidget {
  const Step1Occupation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: context.screenPadding.copyWith(top: 24, bottom: 16),
              child: const OnboardingStepHeader(
                title: 'What do you do?',
                subtitle:
                    'We\'ll tailor your schedule based on your type of work or study.',
                emoji: '💼',
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: context.screenPadding.copyWith(bottom: 16),
                itemCount: OccupationConstants.occupations.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final occ = OccupationConstants.occupations[index];
                  final isSelected = state.occupationId == occ['id'];

                  return SelectionCard(
                    label: occ['label'] as String,
                    emoji: occ['emoji'] as String,
                    isSelected: isSelected,
                    onTap: () {
                      context.read<OnboardingBloc>().add(
                            OnboardingOccupationSelected(
                              occupationId: occ['id'] as String,
                              occupationLabel: occ['label'] as String,
                              occupationType: occ['type'] as String,
                            ),
                          );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
