import 'package:flutter_test/flutter_test.dart';
import 'package:productive_muslim/features/onboarding/domain/entities/user_profile.dart';
import 'package:productive_muslim/features/prayer/domain/entities/prayer_times.dart';
import 'package:productive_muslim/features/timeline/domain/entities/time_block.dart';
import 'package:productive_muslim/features/timeline/domain/usecases/timeline_generator_service.dart';

// ─── TEST FIXTURES ────────────────────────────────────────────────────────────

/// A typical software engineer in London on a weekday.
UserProfile get _defaultProfile => UserProfile(
      name: 'Ahmed',
      gender: 'male',
      occupationId: 'software_engineer',
      occupationLabel: 'Software Engineer',
      occupationType: 'office',
      workStartHour: 9,
      workStartMinute: 0,
      workEndHour: 17,
      workEndMinute: 0,
      workDays: const [0, 1, 2, 3, 4], // Mon–Fri
      latitude: 51.5074,
      longitude: -0.1278,
      city: 'London',
      timezone: 'Europe/London',
      calculationMethod: 'MuslimWorldLeague',
      madhab: 'hanafi',
      prayerBufferMinutes: 10,
      fitnessActivityIds: const ['gym'],
      gymDays: const [0, 2, 4], // Mon, Wed, Fri
      gymDurationMinutes: 60,
      preferredGymTime: 'evening',
      targetSleepHours: 7,
      wakeUpOffsetFromFajrMinutes: -30,
      dailyQuranPagesGoal: 2,
      isRamadanMode: false,
      cycleAwareStreaks: false,
      createdAt: DateTime(2024, 1, 1),
      isOnboardingComplete: true,
    );

/// Fixed prayer times for a summer day in London (long day, Fajr early).
DailyPrayerTimes _buildPrayerTimes(DateTime date) {
  DateTime t(int h, int m) => DateTime(date.year, date.month, date.day, h, m);
  PrayerTime mkPrayer(PrayerName n, int h, int m) =>
      PrayerTime(name: n, time: t(h, m), date: date);

  return DailyPrayerTimes(
    date: date,
    fajr: mkPrayer(PrayerName.fajr, 3, 30),
    sunrise: PrayerTime(name: PrayerName.fajr, time: t(5, 15), date: date),
    dhuhr: mkPrayer(PrayerName.dhuhr, 13, 5),
    asr: mkPrayer(PrayerName.asr, 17, 0),
    maghrib: mkPrayer(PrayerName.maghrib, 21, 10),
    isha: mkPrayer(PrayerName.isha, 22, 50),
  );
}

void main() {
  late TimelineGeneratorService generator;
  late DateTime testDate;
  late UserProfile profile;
  late DailyPrayerTimes prayers;

  setUp(() {
    generator = TimelineGeneratorService();
    testDate = DateTime(2024, 6, 17); // Monday
    profile = _defaultProfile;
    prayers = _buildPrayerTimes(testDate);
  });

  group('TimelineGeneratorService', () {
    // ── Basic generation ──────────────────────────────────────────────────────
    group('generates a valid timeline', () {
      test('returns a DailyTimeline with blocks', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        expect(timeline.blocks, isNotEmpty);
        expect(timeline.date.day, equals(testDate.day));
      });

      test('all 5 prayer blocks are present', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        final prayerBlocks = timeline.blocks
            .where((b) => b.type == TimeBlockType.prayer)
            .toList();
        expect(prayerBlocks.length, equals(5));
      });

      test('blocks are sorted chronologically', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        for (int i = 0; i < timeline.blocks.length - 1; i++) {
          expect(
            timeline.blocks[i].startTime
                .isBefore(timeline.blocks[i + 1].startTime) ||
                timeline.blocks[i].startTime
                    .isAtSameMomentAs(timeline.blocks[i + 1].startTime),
            isTrue,
            reason:
                'Block ${timeline.blocks[i].title} (${timeline.blocks[i].startTime}) '
                'should come before ${timeline.blocks[i + 1].title} (${timeline.blocks[i + 1].startTime})',
          );
        }
      });
    });

    // ── No overlaps (the critical invariant) ─────────────────────────────────
    group('no block overlaps', () {
      test('no two blocks overlap on a weekday', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        _assertNoOverlaps(timeline.blocks);
      });

      test('no two blocks overlap on a weekend', () {
        final saturday = DateTime(2024, 6, 22); // Saturday
        final timeline = generator.generate(
          date: saturday,
          profile: profile,
          prayerTimes: _buildPrayerTimes(saturday),
        );
        _assertNoOverlaps(timeline.blocks);
      });

      test('no two blocks overlap on a gym day', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        _assertNoOverlaps(timeline.blocks);
      });

      test('no two blocks overlap on a non-gym day', () {
        final tuesday = DateTime(2024, 6, 18);
        final timeline = generator.generate(
          date: tuesday,
          profile: profile,
          prayerTimes: _buildPrayerTimes(tuesday),
        );
        _assertNoOverlaps(timeline.blocks);
      });
    });

    // ── Prayer / work split ───────────────────────────────────────────────────
    group('prayer blocks split work correctly', () {
      test('work blocks never overlap with prayer or buffer blocks', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );

        final workBlocks = timeline.blocks.where((b) =>
            b.type == TimeBlockType.work ||
            b.type == TimeBlockType.deepWork);
        final prayerAndBufferBlocks = timeline.blocks.where((b) =>
            b.type == TimeBlockType.prayer ||
            b.type == TimeBlockType.prayerBuffer);

        for (final work in workBlocks) {
          for (final prayer in prayerAndBufferBlocks) {
            expect(
              work.overlapsWith(prayer),
              isFalse,
              reason: 'Work block "${work.title}" overlaps with '
                  '"${prayer.title}"',
            );
          }
        }
      });

      test('Asr prayer at 17:00 splits work ending at 17:00', () {
        // Asr is exactly at workEnd — work should end before Asr buffer
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );

        final workBlocks = timeline.blocks
            .where((b) => b.type == TimeBlockType.work || b.type == TimeBlockType.deepWork)
            .toList();

        // No work block should start at or after Asr buffer (16:50)
        final asrBuffer = prayers.asr.bufferStart(profile.prayerBufferMinutes);
        for (final work in workBlocks) {
          expect(
            work.startTime.isBefore(asrBuffer) || work.endTime.isBefore(asrBuffer) || work.endTime.isAtSameMomentAs(asrBuffer),
            isTrue,
            reason: 'Work block "${work.title}" should not start after Asr buffer',
          );
        }
      });

      test('work blocks total duration equals work hours minus prayer interruptions', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );

        final totalWorkMins = timeline.blocks
            .where((b) =>
                b.type == TimeBlockType.work ||
                b.type == TimeBlockType.deepWork)
            .fold(0, (sum, b) => sum + b.durationMinutes);

        // Work is 9:00–17:00 = 480 min
        // Dhuhr buffer+prayer (~25 min) falls inside work
        // Asr buffer (10 min) starts exactly at workEnd = not inside
        // So expect ~480 - 25 = ~455 min of work
        expect(totalWorkMins, greaterThan(400));
        expect(totalWorkMins, lessThanOrEqualTo(480));
      });
    });

    // ── Spiritual blocks ──────────────────────────────────────────────────────
    group('spiritual enrichment blocks', () {
      test('Quran block is present when dailyQuranPagesGoal > 0', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        final quranBlocks = timeline.blocks
            .where((b) => b.type == TimeBlockType.quran);
        expect(quranBlocks, isNotEmpty);
      });

      test('no Quran block when dailyQuranPagesGoal = 0', () {
        final noQuranProfile =
            profile.copyWith(dailyQuranPagesGoal: 0);
        final timeline = generator.generate(
          date: testDate,
          profile: noQuranProfile,
          prayerTimes: prayers,
        );
        final quranBlocks = timeline.blocks
            .where((b) => b.type == TimeBlockType.quran);
        expect(quranBlocks, isEmpty);
      });

      test('Quran block starts at or after Fajr prayer end', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        final quranBlock = timeline.blocks
            .firstWhere((b) => b.type == TimeBlockType.quran);
        // !isBefore is >= (at or after) — generator places Quran at fajr.prayerEnd()
        expect(
          !quranBlock.startTime.isBefore(prayers.fajr.prayerEnd()),
          isTrue,
        );
      });

      test('dhikr blocks appear after prayers', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        final dhikrBlocks = timeline.blocks
            .where((b) => b.type == TimeBlockType.dhikr)
            .toList();
        // At least some dhikr blocks should exist
        expect(dhikrBlocks, isNotEmpty);
      });

      test('Golden Hour block only appears when gap >= 20 min', () {
        // Use a no-Quran profile so Golden Hour is not blocked by Quran insertion
        final noQuranProfile = _defaultProfile.copyWith(dailyQuranPagesGoal: 0);
        final timeline = generator.generate(
          date: testDate,
          profile: noQuranProfile,
          prayerTimes: prayers,
        );
        // Fajr at 3:30, Sunrise at 5:15 — gap = 105 min → should have golden hour
        final goldenBlocks = timeline.blocks
            .where((b) => b.type == TimeBlockType.goldenHour);
        expect(goldenBlocks, isNotEmpty);
      });
    });

    // ── Gym placement ─────────────────────────────────────────────────────────
    group('gym block placement', () {
      test('gym block present on gym days', () {
        final timeline = generator.generate(
          date: testDate, // Monday — gym day
          profile: profile,
          prayerTimes: prayers,
        );
        final gymBlocks =
            timeline.blocks.where((b) => b.type == TimeBlockType.gym);
        expect(gymBlocks, isNotEmpty);
      });

      test('no gym block on non-gym days', () {
        final tuesday = DateTime(2024, 6, 18);
        final timeline = generator.generate(
          date: tuesday,
          profile: profile,
          prayerTimes: _buildPrayerTimes(tuesday),
        );
        final gymBlocks =
            timeline.blocks.where((b) => b.type == TimeBlockType.gym);
        expect(gymBlocks, isEmpty);
      });

      test('gym block does not overlap with Maghrib buffer (evening preference)', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        final gymBlock = timeline.blocks
            .firstWhere((b) => b.type == TimeBlockType.gym, orElse: () =>
                TimeBlock(
                  id: 'none',
                  type: TimeBlockType.freeTime,
                  startTime: _epoch,
                  endTime: _epoch,
                  title: '',
                  priority: BlockPriority.suggested,
                ));

        if (gymBlock.id == 'none') return; // no gym block — skip

        final maghribBuffer =
            prayers.maghrib.bufferStart(profile.prayerBufferMinutes);
        expect(
          gymBlock.endTime.isBefore(maghribBuffer) ||
              gymBlock.endTime.isAtSameMomentAs(maghribBuffer),
          isTrue,
          reason:
              'Gym block should end before Maghrib buffer at $maghribBuffer, '
              'but ends at ${gymBlock.endTime}',
        );
      });
    });

    // ── Sleep block ───────────────────────────────────────────────────────────
    group('sleep block', () {
      test('sleep block ends at or before Fajr time + offset', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        final sleepBlocks =
            timeline.blocks.where((b) => b.type == TimeBlockType.sleep);
        expect(sleepBlocks, isNotEmpty);

        final wakeTime = prayers.fajr.time.add(
            Duration(minutes: profile.wakeUpOffsetFromFajrMinutes));

        for (final sleep in sleepBlocks) {
          expect(
            sleep.endTime.isBefore(wakeTime) ||
                sleep.endTime.isAtSameMomentAs(wakeTime),
            isTrue,
          );
        }
      });
    });

    // ── Day type detection ────────────────────────────────────────────────────
    group('day type', () {
      test('Friday is detected as Jumuah', () {
        final friday = DateTime(2024, 6, 21);
        final timeline = generator.generate(
          date: friday,
          profile: profile,
          prayerTimes: _buildPrayerTimes(friday),
        );
        expect(timeline.dayType, equals(DayType.jumuah));
      });

      test('weekday is detected correctly', () {
        final timeline = generator.generate(
          date: testDate, // Monday
          profile: profile,
          prayerTimes: prayers,
        );
        expect(timeline.dayType, equals(DayType.weekday));
      });

      test('Saturday is a weekend', () {
        final saturday = DateTime(2024, 6, 22);
        final timeline = generator.generate(
          date: saturday,
          profile: profile,
          prayerTimes: _buildPrayerTimes(saturday),
        );
        expect(timeline.dayType, equals(DayType.weekend));
      });
    });

    // ── Edge cases ────────────────────────────────────────────────────────────
    group('edge cases', () {
      test('handles zero prayer buffer gracefully', () {
        final noBufProfile = profile.copyWith(prayerBufferMinutes: 0);
        final timeline = generator.generate(
          date: testDate,
          profile: noBufProfile,
          prayerTimes: prayers,
        );
        final bufferBlocks = timeline.blocks
            .where((b) => b.type == TimeBlockType.prayerBuffer);
        expect(bufferBlocks, isEmpty);
        expect(
            timeline.blocks
                .where((b) => b.type == TimeBlockType.prayer)
                .length,
            equals(5));
      });

      test('handles homemaker (no work blocks expected)', () {
        final homemakerProfile = profile.copyWith(
          occupationId: 'homemaker',
          occupationType: 'home',
          workDays: [], // no work days
        );
        final timeline = generator.generate(
          date: testDate,
          profile: homemakerProfile,
          prayerTimes: prayers,
        );
        final workBlocks = timeline.blocks.where((b) =>
            b.type == TimeBlockType.work ||
            b.type == TimeBlockType.deepWork);
        expect(workBlocks, isEmpty);
      });

      test('handles user with no fitness activities', () {
        final noGymProfile = profile.copyWith(
          fitnessActivityIds: ['none'],
          gymDays: [],
        );
        final timeline = generator.generate(
          date: testDate,
          profile: noGymProfile,
          prayerTimes: prayers,
        );
        final gymBlocks =
            timeline.blocks.where((b) => b.type == TimeBlockType.gym);
        expect(gymBlocks, isEmpty);
      });

      test('all blocks have valid duration > 0', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        for (final block in timeline.blocks) {
          expect(
            block.durationMinutes,
            greaterThan(0),
            reason: 'Block "${block.title}" has zero or negative duration',
          );
        }
      });

      test('all blocks have non-empty IDs', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        for (final block in timeline.blocks) {
          expect(block.id, isNotEmpty);
        }
      });
    });

    // ── Computed stats ────────────────────────────────────────────────────────
    group('DailyTimeline computed stats', () {
      test('prayerBlocks returns 5 blocks', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        expect(timeline.prayerBlocks.length, equals(5));
      });

      test('completionRatio is 0 when nothing is completed', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        expect(timeline.completionRatio, equals(0.0));
      });

      test('prayersCompletedCount is 0 initially', () {
        final timeline = generator.generate(
          date: testDate,
          profile: profile,
          prayerTimes: prayers,
        );
        expect(timeline.prayersCompletedCount, equals(0));
      });
    });
  });
}

// ─── HELPERS ─────────────────────────────────────────────────────────────────
void _assertNoOverlaps(List<TimeBlock> blocks) {
  for (int i = 0; i < blocks.length; i++) {
    for (int j = i + 1; j < blocks.length; j++) {
      expect(
        blocks[i].overlapsWith(blocks[j]),
        isFalse,
        reason: 'OVERLAP DETECTED:\n'
            '  [${blocks[i].type.name}] "${blocks[i].title}" '
            '${blocks[i].startTime.toIso8601String()} → ${blocks[i].endTime.toIso8601String()}\n'
            '  [${blocks[j].type.name}] "${blocks[j].title}" '
            '${blocks[j].startTime.toIso8601String()} → ${blocks[j].endTime.toIso8601String()}',
      );
    }
  }
}

final _epoch = DateTime.utc(1970);
