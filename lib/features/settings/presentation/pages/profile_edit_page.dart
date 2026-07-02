import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../features/onboarding/domain/entities/user_profile.dart';
import '../../../../features/timeline/presentation/bloc/timeline_bloc.dart';

class ProfileEditPage extends StatefulWidget {
  final UserProfile? profile;
  const ProfileEditPage({super.key, this.profile});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _cityCtrl;

  String _occupationId = 'software_engineer';
  String _occupationLabel = 'Software Engineer';
  String _occupationType = 'office';

  TimeOfDay _workStart = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _workEnd = const TimeOfDay(hour: 17, minute: 0);
  final Set<int> _workDays = {0, 1, 2, 3, 4}; // Mon–Fri

  int _quranPages = 2;
  int _sleepHours = 7;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _cityCtrl = TextEditingController(text: p?.city ?? '');

    if (p != null) {
      _occupationId = p.occupationId;
      _occupationLabel = p.occupationLabel;
      _occupationType = p.occupationType;
      _workStart = TimeOfDay(hour: p.workStartHour, minute: p.workStartMinute);
      _workEnd = TimeOfDay(hour: p.workEndHour, minute: p.workEndMinute);
      _workDays
        ..clear()
        ..addAll(p.workDays);
      _quranPages = p.dailyQuranPagesGoal;
      _sleepHours = p.targetSleepHours;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Save',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.primary),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection('Personal Info', [
              _buildTextfield(
                controller: _nameCtrl,
                label: 'Full Name',
                icon: Icons.person_outline,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              _buildTextfield(
                controller: _cityCtrl,
                label: 'City',
                icon: Icons.location_city_outlined,
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection('Occupation', [
              _buildOccupationDropdown(),
            ]),
            const SizedBox(height: 16),
            _buildSection('Work Schedule', [
              _buildTimePicker(
                label: 'Work Start',
                icon: Icons.login_outlined,
                time: _workStart,
                onTap: () => _pickTime(isStart: true),
              ),
              const Divider(height: 1, indent: 52),
              _buildTimePicker(
                label: 'Work End',
                icon: Icons.logout_outlined,
                time: _workEnd,
                onTap: () => _pickTime(isStart: false),
              ),
              const Divider(height: 1, indent: 52),
              _buildWorkDaysPicker(),
            ]),
            const SizedBox(height: 16),
            _buildSection('Daily Goals', [
              _buildStepper(
                label: 'Quran pages / day',
                icon: Icons.menu_book_outlined,
                value: _quranPages,
                min: 1,
                max: 20,
                onChanged: (v) => setState(() => _quranPages = v),
              ),
              const Divider(height: 1, indent: 52),
              _buildStepper(
                label: 'Sleep target (hours)',
                icon: Icons.bedtime_outlined,
                value: _sleepHours,
                min: 5,
                max: 10,
                onChanged: (v) => setState(() => _sleepHours = v),
              ),
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Builders ─────────────────────────────────────────────────────────────────

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.labelSmall
                .copyWith(color: AppColors.textHint, letterSpacing: 1.2),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildTextfield({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildOccupationDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _occupationId,
      decoration: InputDecoration(
        labelText: 'Occupation',
        prefixIcon:
            const Icon(Icons.work_outline, color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: OccupationConstants.occupations
          .map((o) => DropdownMenuItem<String>(
                value: o['id'] as String,
                child: Text('${o['emoji']} ${o['label']}'),
              ))
          .toList(),
      onChanged: (id) {
        if (id == null) return;
        final occ = OccupationConstants.occupations
            .firstWhere((o) => o['id'] == id);
        setState(() {
          _occupationId = id;
          _occupationLabel = occ['label'] as String;
          _occupationType = occ['type'] as String;
        });
      },
    );
  }

  Widget _buildTimePicker({
    required String label,
    required IconData icon,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: AppTextStyles.labelLarge),
            ),
            Text(
              time.format(context),
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkDaysPicker() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 16),
              Text('Work Days', style: AppTextStyles.labelLarge),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final selected = _workDays.contains(i);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) {
                    _workDays.remove(i);
                  } else {
                    _workDays.add(i);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    days[i],
                    style: AppTextStyles.labelSmall.copyWith(
                      color: selected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper({
    required String label,
    required IconData icon,
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: AppTextStyles.labelLarge)),
          IconButton(
            onPressed:
                value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.primary,
            iconSize: 22,
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium
                  .copyWith(color: AppColors.primary),
            ),
          ),
          IconButton(
            onPressed:
                value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.primary,
            iconSize: 22,
          ),
        ],
      ),
    );
  }

  // ── Actions ──────────────────────────────────────────────────────────────────

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _workStart : _workEnd,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _workStart = picked;
      } else {
        _workEnd = picked;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final p = widget.profile;
    if (p == null) return;

    setState(() => _isSaving = true);

    final updated = p.copyWith(
      name: _nameCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      occupationId: _occupationId,
      occupationLabel: _occupationLabel,
      occupationType: _occupationType,
      workStartHour: _workStart.hour,
      workStartMinute: _workStart.minute,
      workEndHour: _workEnd.hour,
      workEndMinute: _workEnd.minute,
      workDays: _workDays.toList()..sort(),
      dailyQuranPagesGoal: _quranPages,
      targetSleepHours: _sleepHours,
    );

    final result = await AppDependencies.updateUserProfile(updated);

    result.fold(
      (failure) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: ${failure.message}')),
        );
      },
      (savedProfile) {
        // Recalculate today's timeline with the updated profile
        if (context.mounted) {
          context.read<TimelineBloc>().add(TimelineGenerateRequested(
                profile: savedProfile,
                date: DateTime.now(),
              ));
        }
        setState(() => _isSaving = false);
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}
