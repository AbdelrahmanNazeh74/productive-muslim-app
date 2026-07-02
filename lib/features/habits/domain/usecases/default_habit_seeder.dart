import 'package:uuid/uuid.dart';
import '../entities/habit.dart';

/// Generates the starter set of habits from the user's onboarding profile.
///
/// These are "system habits" — they can be toggled off but not deleted,
/// ensuring the spiritual core is always present.
class DefaultHabitSeeder {
  static const _uuid = Uuid();

  static List<Habit> seed({
    required String gender,
    required bool hasFitness,
    required int quranPagesGoal,
    required bool cycleAware,
    required List<int> gymDays,
  }) {
    final habits = <Habit>[];
    final now = DateTime.now();

    // ── 5 Daily Prayers (always seeded) ──────────────────────────────────────
    // Each prayer is a separate habit so streaks are independent.
    // Prayer names and their time anchors match the timeline blocks.
    final prayers = [
      ('Fajr Prayer', '🌅', 'post_fajr'),
      ('Dhuhr Prayer', '☀️', 'midday'),
      ('Asr Prayer', '🌤', 'afternoon'),
      ('Maghrib Prayer', '🌆', 'evening'),
      ('Isha Prayer', '🌙', 'night'),
    ];

    for (final (name, emoji, anchor) in prayers) {
      habits.add(Habit(
        id: _uuid.v4(),
        name: name,
        emoji: emoji,
        category: HabitCategory.spiritual,
        description: 'Pray on time, every day.',
        targetFrequencyPerWeek: 7,
        scheduledDays: const [],   // every day
        timeAnchor: anchor,
        isActive: true,
        streakPauseOnCycle: cycleAware && gender == 'female',
        isSystemHabit: true,
        createdAt: now,
      ));
    }

    // ── Quran Reading ─────────────────────────────────────────────────────────
    if (quranPagesGoal > 0) {
      habits.add(Habit(
        id: _uuid.v4(),
        name: 'Quran Reading',
        emoji: '📖',
        category: HabitCategory.spiritual,
        description:
            '$quranPagesGoal page${quranPagesGoal > 1 ? 's' : ''} daily · '
            '${(604 / quranPagesGoal).ceil()} days to Khatm',
        targetFrequencyPerWeek: 7,
        scheduledDays: const [],
        timeAnchor: 'post_fajr',
        isActive: true,
        streakPauseOnCycle: cycleAware && gender == 'female',
        isSystemHabit: true,
        createdAt: now,
      ));
    }

    // ── Dhikr (Post-Prayer) ───────────────────────────────────────────────────
    habits.add(Habit(
      id: _uuid.v4(),
      name: 'Morning Adhkar',
      emoji: '📿',
      category: HabitCategory.spiritual,
      description: 'Adhkar after Fajr · SubhanAllah, Alhamdulillah, Allahu Akbar',
      targetFrequencyPerWeek: 7,
      scheduledDays: const [],
      timeAnchor: 'post_fajr',
      isActive: true,
      streakPauseOnCycle: cycleAware && gender == 'female',
      isSystemHabit: true,
      createdAt: now,
    ));

    habits.add(Habit(
      id: _uuid.v4(),
      name: 'Evening Adhkar',
      emoji: '📿',
      category: HabitCategory.spiritual,
      description: 'Adhkar after Asr · Evening remembrance',
      targetFrequencyPerWeek: 7,
      scheduledDays: const [],
      timeAnchor: 'afternoon',
      isActive: true,
      streakPauseOnCycle: cycleAware && gender == 'female',
      isSystemHabit: true,
      createdAt: now,
    ));

    // ── Sunnah Habits (always included) ──────────────────────────────────────
    habits.add(Habit(
      id: _uuid.v4(),
      name: 'Sleep Early',
      emoji: '🛌',
      category: HabitCategory.health,
      description: 'Sleep before midnight for quality Fajr',
      targetFrequencyPerWeek: 7,
      scheduledDays: const [],
      timeAnchor: 'night',
      isActive: true,
      isSystemHabit: false,
      createdAt: now,
    ));

    habits.add(Habit(
      id: _uuid.v4(),
      name: 'Drink 8 Glasses of Water',
      emoji: '💧',
      category: HabitCategory.health,
      description: 'Stay hydrated throughout the day',
      targetFrequencyPerWeek: 7,
      scheduledDays: const [],
      timeAnchor: 'anytime',
      isActive: true,
      isSystemHabit: false,
      createdAt: now,
    ));

    habits.add(Habit(
      id: _uuid.v4(),
      name: 'Qaylula Nap',
      emoji: '💤',
      category: HabitCategory.health,
      description: 'Sunnah midday nap · Recharge before Asr',
      targetFrequencyPerWeek: 5,
      scheduledDays: const [0, 1, 2, 3, 4], // weekdays
      timeAnchor: 'midday',
      isActive: true,
      isSystemHabit: false,
      createdAt: now,
    ));

    // ── Fitness (only if user selected activities) ────────────────────────────
    if (hasFitness) {
      habits.add(Habit(
        id: _uuid.v4(),
        name: 'Workout Session',
        emoji: '🏋️',
        category: HabitCategory.fitness,
        description: 'Complete your scheduled workout',
        targetFrequencyPerWeek: gymDays.length,
        scheduledDays: gymDays,
        timeAnchor: 'evening',
        isActive: true,
        isSystemHabit: true,
        createdAt: now,
      ));
    }

    // ── Female-specific ───────────────────────────────────────────────────────
    if (gender == 'female') {
      habits.add(Habit(
        id: _uuid.v4(),
        name: 'Gratitude Journal',
        emoji: '✍️',
        category: HabitCategory.personal,
        description: "Write 3 things you're grateful for today",
        targetFrequencyPerWeek: 7,
        scheduledDays: const [],
        timeAnchor: 'evening',
        isActive: true,
        streakPauseOnCycle: cycleAware,
        isSystemHabit: false,
        createdAt: now,
      ));
    }

    // ── Universal personal habits ─────────────────────────────────────────────
    habits.add(Habit(
      id: _uuid.v4(),
      name: 'Read / Learn',
      emoji: '📚',
      category: HabitCategory.personal,
      description: '15+ minutes of beneficial reading or learning',
      targetFrequencyPerWeek: 5,
      scheduledDays: const [],
      timeAnchor: 'evening',
      isActive: true,
      isSystemHabit: false,
      createdAt: now,
    ));

    return habits;
  }
}
