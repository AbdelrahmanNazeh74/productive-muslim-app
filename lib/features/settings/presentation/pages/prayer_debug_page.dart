import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/app_dependencies.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../prayer/domain/entities/prayer_times.dart';

class PrayerDebugPage extends StatefulWidget {
  const PrayerDebugPage({super.key});

  @override
  State<PrayerDebugPage> createState() => _PrayerDebugPageState();
}

class _PrayerDebugPageState extends State<PrayerDebugPage> {
  UserProfile? _profile;
  DailyPrayerTimes? _prayerTimes;
  String? _error;
  bool _loading = true;
  bool _rewarming = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) setState(() { _loading = true; _error = null; });

    final profileResult = await AppDependencies.getUserProfile(const NoParams());
    final profile = profileResult.fold((_) => null, (p) => p);

    if (profile == null) {
      if (mounted) {
        setState(() { _error = 'No profile found in storage'; _loading = false; });
      }
      return;
    }

    final timesResult = AppDependencies.prayerTimeService.getPrayerTimes(
      profile: profile,
      date: DateTime.now(),
    );

    if (!mounted) return;
    setState(() {
      _profile = profile;
      _loading = false;
      timesResult.fold(
        (failure) => _error = failure.message,
        (times) => _prayerTimes = times,
      );
    });
  }

  Future<void> _rewarmCache() async {
    if (_profile == null || _rewarming) return;
    setState(() => _rewarming = true);
    await AppDependencies.prayerCacheService.warmCache(_profile!);
    if (mounted) setState(() => _rewarming = false);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Prayer Debug'),
        backgroundColor: bg,
        elevation: 0,
        actions: [
          if (_rewarming)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.cached),
              onPressed: _rewarmCache,
              tooltip: 'Rewarm prayer cache',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError(cs)
              : _buildContent(cs),
    );
  }

  Widget _buildError(ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, size: 48, color: cs.error),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(color: cs.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _load,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme cs) {
    final p = _profile!;
    final pt = _prayerTimes!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _card(cs, 'Location', [
          _row(cs, 'City', p.city),
          _divider(cs),
          _row(cs, 'Latitude', p.latitude.toStringAsFixed(6)),
          _divider(cs),
          _row(cs, 'Longitude', p.longitude.toStringAsFixed(6)),
          _divider(cs),
          _row(cs, 'Timezone', p.timezone),
        ]),
        const SizedBox(height: 12),
        _card(cs, 'Calculation', [
          _row(cs, 'Method', p.calculationMethod),
          _divider(cs),
          _row(cs, 'Madhab', p.madhab),
          _divider(cs),
          _row(cs, 'Buffer', '${p.prayerBufferMinutes} min'),
        ]),
        const SizedBox(height: 12),
        _card(cs, "Today's Prayer Times", [
          for (int i = 0; i < pt.ordered.length; i++) ...[
            if (i > 0) _divider(cs),
            _row(
              cs,
              '${pt.ordered[i].name.emoji}  ${pt.ordered[i].name.label}',
              DateFormat('h:mm a').format(pt.ordered[i].time),
            ),
          ],
          _divider(cs),
          _row(cs, '🌅  Sunrise', DateFormat('h:mm a').format(pt.sunrise.time)),
        ]),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _rewarming ? null : _rewarmCache,
            icon: const Icon(Icons.cached),
            label: const Text('Rewarm 30-Day Cache'),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _card(ColorScheme cs, String title, List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              title.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
                letterSpacing: 1.2,
              ),
            ),
          ),
          Divider(height: 1, color: cs.outlineVariant),
          ...rows,
        ],
      ),
    );
  }

  Widget _divider(ColorScheme cs) => Divider(
        height: 1,
        indent: 16,
        color: cs.outlineVariant,
      );

  Widget _row(ColorScheme cs, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}
