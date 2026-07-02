import 'package:home_widget/home_widget.dart';

import '../../features/prayer/domain/entities/prayer_times.dart';
import '../../features/timeline/domain/entities/time_block.dart';

/// Writes the next prayer and current timeline block to the home_widget
/// shared data store, then triggers a native widget redraw on both platforms.
///
/// [update] is fire-and-forget safe — all platform-channel errors are caught
/// so callers in BLoC handlers do not need to await or handle failures.
///
/// [buildData] is pure and has no platform dependencies, making it fully
/// unit-testable without mocking platform channels.
class WidgetUpdateService {
  static const String _appGroupId = 'group.com.example.productiveMuslim';
  static const String _androidName = 'ProductiveMuslimWidgetProvider';
  static const String _iOSName = 'ProductiveMuslimWidget';

  static Future<void> update({
    required DailyTimeline? timeline,
    required DailyPrayerTimes? prayerTimes,
    required DateTime now,
  }) async {
    try {
      await HomeWidget.setAppGroupId(_appGroupId);

      final d = buildData(timeline: timeline, prayerTimes: prayerTimes, now: now);

      await Future.wait([
        HomeWidget.saveWidgetData<String>('nextPrayerName', d.nextPrayerName),
        HomeWidget.saveWidgetData<String>('nextPrayerTime', d.nextPrayerTime),
        HomeWidget.saveWidgetData<String>('timeRemaining', d.timeRemaining),
        HomeWidget.saveWidgetData<String>('currentBlockTitle', d.currentBlockTitle),
      ]);

      await HomeWidget.updateWidget(
        androidName: _androidName,
        iOSName: _iOSName,
        qualifiedAndroidName:
            'com.example.productive_muslim.$_androidName',
      );
    } catch (_) {
      // Platform channel unavailable in unit tests or when widget is not
      // installed — silently ignore so app behaviour is unaffected.
    }
  }

  /// Formats widget display data from domain objects.
  ///
  /// Uses [now] for all time comparisons instead of [DateTime.now()] so
  /// the output is fully deterministic and easily unit-tested.
  static WidgetData buildData({
    required DailyTimeline? timeline,
    required DailyPrayerTimes? prayerTimes,
    required DateTime now,
  }) {
    // ── Next prayer ──────────────────────────────────────────────────────────
    String nextPrayerName = '—';
    String nextPrayerTime = '—';
    String timeRemaining = '—';

    // Prefer prayer blocks from the timeline (they already carry the right title)
    // Use !isBefore so a block starting exactly at `now` counts as upcoming (0m).
    final upcomingPrayerBlocks = timeline?.prayerBlocks
            .where((b) => !b.startTime.isBefore(now) && !b.isCompleted)
            .toList() ??
        [];

    if (upcomingPrayerBlocks.isNotEmpty) {
      final next = upcomingPrayerBlocks.first;
      nextPrayerName = next.title;
      nextPrayerTime = _formatTime(next.startTime);
      timeRemaining = _formatDuration(next.startTime.difference(now));
    } else if (prayerTimes != null) {
      // Fallback: derive next prayer directly from the adhan data
      final upcoming =
          prayerTimes.ordered.where((p) => p.time.isAfter(now)).toList();
      if (upcoming.isNotEmpty) {
        final next = upcoming.first;
        nextPrayerName = next.name.label;
        nextPrayerTime = next.formattedTime;
        timeRemaining = _formatDuration(next.time.difference(now));
      }
    }

    // ── Current / next block ─────────────────────────────────────────────────
    String currentBlockTitle = '—';

    final activeBlocks = timeline?.blocks
            .where((b) => b.startTime.isBefore(now) && b.endTime.isAfter(now))
            .toList() ??
        [];

    if (activeBlocks.isNotEmpty) {
      currentBlockTitle = activeBlocks.first.title;
    } else if (timeline != null) {
      final futureBlocks =
          timeline.blocks.where((b) => b.startTime.isAfter(now)).toList();
      if (futureBlocks.isNotEmpty) {
        currentBlockTitle = 'Up next: ${futureBlocks.first.title}';
      }
    }

    return WidgetData(
      nextPrayerName: nextPrayerName,
      nextPrayerTime: nextPrayerTime,
      timeRemaining: timeRemaining,
      currentBlockTitle: currentBlockTitle,
    );
  }

  // ── Formatting helpers ───────────────────────────────────────────────────────

  static String _formatTime(DateTime dt) {
    final h = dt.hour == 0 ? 12 : dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  static String _formatDuration(Duration d) {
    if (d.isNegative) return '—';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

/// Plain data holder for widget display values — no platform dependencies.
class WidgetData {
  final String nextPrayerName;
  final String nextPrayerTime;
  final String timeRemaining;
  final String currentBlockTitle;

  const WidgetData({
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.timeRemaining,
    required this.currentBlockTitle,
  });
}
