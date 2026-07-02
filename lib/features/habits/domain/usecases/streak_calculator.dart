import '../entities/habit.dart';
export '../entities/habit.dart' show WeeklySpiritualScore, StreakRecord, StreakPauseReason;

/// Pure, stateless streak calculator.
///
/// Design decisions:
/// ─────────────────────────────────────────────────────────────────────────────
/// • A streak is measured in CONSECUTIVE SCHEDULED DAYS — not calendar days.
///   If a habit runs Mon/Wed/Fri, missing Tuesday doesn't break it.
///
/// • An EXCUSED day neither advances nor breaks the streak.
///   It acts as a transparent gap. Example:
///     Mon ✅ → Tue (excused) → Wed ✅  = streak of 2, not broken.
///
/// • For female users with cycleAwareStreaks, days marked with
///   StreakPauseReason.cycle are automatically excused.
///
/// • A streak is BROKEN only when a scheduled day has NO record
///   AND that day is in the past (today doesn't break the streak yet).
/// ─────────────────────────────────────────────────────────────────────────────
class StreakCalculator {
  const StreakCalculator();

  /// Recalculate [currentStreak] and [longestStreak] from a full record list.
  ///
  /// [records] must be sorted chronologically (oldest first).
  /// [scheduledDays] is a list of weekday indices (0=Mon…6=Sun).
  ///   If empty, the habit runs every day.
  StreakResult calculate({
    required List<StreakRecord> records,
    required List<int> scheduledDays,
    required int targetFrequencyPerWeek,
    DateTime? asOf,
  }) {
    final today = _dateOnly(asOf ?? DateTime.now());
    if (records.isEmpty) return const StreakResult(current: 0, longest: 0);

    // Index records by date for O(1) lookup
    final byDate = <DateTime, StreakRecord>{};
    for (final r in records) {
      byDate[_dateOnly(r.date)] = r;
    }

    // Build list of all scheduled dates from first record to today
    // Use min date across all records (caller may pass unsorted)
    final firstDate = byDate.keys.reduce((a, b) => a.isBefore(b) ? a : b);
    final scheduledDates = _scheduledDatesBetween(
      from: firstDate,
      to: today,
      scheduledDays: scheduledDays,
    );

    if (scheduledDates.isEmpty) {
      return const StreakResult(current: 0, longest: 0);
    }

    int current = 0;
    int longest = 0;
    int runningStreak = 0;

    for (final date in scheduledDates) {
      final record = byDate[date];
      final isPast = date.isBefore(today);
      final isToday = date.isAtSameMomentAs(today);

      if (record == null) {
        if (isPast) {
          // Missed a past scheduled day → break streak
          runningStreak = 0;
        }
        // Today with no record yet → don't break (still time to complete)
      } else if (record.excused) {
        // Excused → transparent, don't change running streak
        // (neither advances nor breaks)
      } else if (record.completed) {
        runningStreak++;
        if (runningStreak > longest) longest = runningStreak;
      } else {
        // Record exists but not completed and not excused (e.g. skipped)
        if (isPast) runningStreak = 0;
      }

      if (isToday || date.isAtSameMomentAs(today)) {
        current = runningStreak;
      }
    }

    // If we never hit today in the loop (future-only schedule),
    // current = the last running value
    if (current == 0 && runningStreak > 0) current = runningStreak;
    if (longest < current) longest = current;

    return StreakResult(current: current, longest: longest);
  }

  /// Calculate whether today's completion would set a new personal best.
  bool wouldSetNewRecord({
    required int currentStreak,
    required int longestStreak,
  }) {
    return currentStreak + 1 > longestStreak;
  }

  /// Given records for the current week, how many target days remain?
  int remainingThisWeek({
    required int completedThisWeek,
    required int targetFrequencyPerWeek,
  }) {
    return (targetFrequencyPerWeek - completedThisWeek).clamp(0, 7);
  }

  /// Build the 7-day heat map for the last 7 days (Sun…Sat or Mon…Sun).
  List<DayStatus> buildRecentHeatMap({
    required List<StreakRecord> records,
    required List<int> scheduledDays,
    int lookbackDays = 7,
  }) {
    final today = _dateOnly(DateTime.now());
    final result = <DayStatus>[];

    for (int i = lookbackDays - 1; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final weekdayIndex = date.weekday - 1; // 0=Mon
      final isScheduled = scheduledDays.isEmpty ||
          scheduledDays.contains(weekdayIndex);

      if (!isScheduled) {
        result.add(DayStatus(date: date, status: DayStatusType.notScheduled));
        continue;
      }

      final record = records.firstWhere(
        (r) => _dateOnly(r.date).isAtSameMomentAs(date),
        orElse: () => StreakRecord(
          id: '',
          habitId: '',
          date: date,
          completed: false,
        ),
      );

      final isToday = date.isAtSameMomentAs(today);

      DayStatusType status;
      if (record.id.isEmpty && isToday) {
        status = DayStatusType.pending;
      } else if (record.id.isEmpty) {
        status = DayStatusType.missed;
      } else if (record.excused) {
        status = DayStatusType.excused;
      } else if (record.completed) {
        status = DayStatusType.completed;
      } else {
        status = isToday ? DayStatusType.pending : DayStatusType.missed;
      }

      result.add(DayStatus(date: date, status: status));
    }

    return result;
  }

  // ─── WEEKLY SPIRITUAL SCORE CALCULATION ────────────────────────────────────
  WeeklySpiritualScore calculateWeeklyScore({
    required DateTime weekStart,
    required List<StreakRecord> prayerRecords,    // up to 35 (5×7)
    required List<StreakRecord> quranRecords,     // up to 7
    required List<StreakRecord> habitRecords,     // all other habits
    required int habitTargetCount,               // total habit×day targets
    required List<StreakRecord> gymRecords,
    required int gymTargetCount,
  }) {
    // Prayer score: each on-time prayer = 1 point, max 35
    final prayersCompleted =
        prayerRecords.where((r) => r.completed).length;
    final prayerScore =
        ((prayersCompleted / 35) * 100).round().clamp(0, 100);

    // Quran score: days with at least one completion
    final quranDays = quranRecords.where((r) => r.completed).length;
    final quranScore = ((quranDays / 7) * 100).round().clamp(0, 100);

    // Habits score
    final habitsCompleted =
        habitRecords.where((r) => r.completed).length;
    final habitsScore = habitTargetCount == 0
        ? 100
        : ((habitsCompleted / habitTargetCount) * 100)
            .round()
            .clamp(0, 100);

    // Gym score
    final gymCompleted = gymRecords.where((r) => r.completed).length;
    final gymScore = gymTargetCount == 0
        ? 100
        : ((gymCompleted / gymTargetCount) * 100).round().clamp(0, 100);

    return WeeklySpiritualScore(
      weekStart: weekStart,
      prayerScore: prayerScore,
      quranScore: quranScore,
      habitsScore: habitsScore,
      gymScore: gymScore,
    );
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────────
  DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  List<DateTime> _scheduledDatesBetween({
    required DateTime from,
    required DateTime to,
    required List<int> scheduledDays,
  }) {
    final dates = <DateTime>[];
    var current = from;
    while (!current.isAfter(to)) {
      final weekdayIndex = current.weekday - 1; // 0=Mon
      if (scheduledDays.isEmpty || scheduledDays.contains(weekdayIndex)) {
        dates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }
    return dates;
  }
}

// ─── VALUE OBJECTS ───────────────────────────────────────────────────────────
class StreakResult {
  final int current;
  final int longest;
  const StreakResult({required this.current, required this.longest});
}

enum DayStatusType { completed, missed, excused, pending, notScheduled }

class DayStatus {
  final DateTime date;
  final DayStatusType status;
  const DayStatus({required this.date, required this.status});
}
