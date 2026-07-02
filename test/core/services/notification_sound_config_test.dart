import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productive_muslim/core/services/notification_sound_config.dart';

void main() {
  // ── NotificationChannels ────────────────────────────────────────────────────

  group('NotificationChannels — channel IDs', () {
    test('prayerAdhan has correct channel ID', () {
      expect(NotificationChannels.prayerAdhan.id, 'prayer_adhan');
    });

    test('prayerBuffer has correct channel ID', () {
      expect(NotificationChannels.prayerBuffer.id, 'prayer_buffer');
    });

    test('quranReminder has correct channel ID', () {
      expect(NotificationChannels.quranReminder.id, 'quran_reminder');
    });

    test('habitReminder has correct channel ID', () {
      expect(NotificationChannels.habitReminder.id, 'habit_reminder');
    });

    test('iftarAdhan has correct channel ID', () {
      expect(NotificationChannels.iftarAdhan.id, 'iftar_adhan');
    });

    test('general has correct channel ID', () {
      expect(NotificationChannels.general.id, 'general');
    });
  });

  group('NotificationChannels — importance levels', () {
    test('prayerAdhan importance is max', () {
      expect(NotificationChannels.prayerAdhan.importance, Importance.max);
    });

    test('prayerBuffer importance is high', () {
      expect(NotificationChannels.prayerBuffer.importance, Importance.high);
    });

    test('quranReminder importance is default', () {
      expect(
          NotificationChannels.quranReminder.importance, Importance.defaultImportance);
    });

    test('habitReminder importance is default', () {
      expect(
          NotificationChannels.habitReminder.importance, Importance.defaultImportance);
    });

    test('iftarAdhan importance is max', () {
      expect(NotificationChannels.iftarAdhan.importance, Importance.max);
    });

    test('general importance is low', () {
      expect(NotificationChannels.general.importance, Importance.low);
    });
  });

  group('NotificationChannels — all list', () {
    test('all contains exactly 6 channels', () {
      expect(NotificationChannels.all.length, 6);
    });

    test('all channel IDs are unique', () {
      final ids = NotificationChannels.all.map((c) => c.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('all contains prayerAdhan, prayerBuffer, quranReminder, habitReminder, iftarAdhan, general', () {
      final ids = NotificationChannels.all.map((c) => c.id).toSet();
      expect(ids, containsAll([
        'prayer_adhan',
        'prayer_buffer',
        'quran_reminder',
        'habit_reminder',
        'iftar_adhan',
        'general',
      ]));
    });
  });

  // ── NotificationSoundConfig.kSoundFilesPresent ──────────────────────────────

  group('NotificationSoundConfig — kSoundFilesPresent fallback', () {
    test('kSoundFilesPresent defaults to false (no MP3 files committed)', () {
      // Ensures the app works out-of-the-box without requiring audio files.
      // Developer flips this to true after placing MP3s in res/raw/.
      expect(NotificationSoundConfig.kSoundFilesPresent, isFalse);
    });

    test('androidSound returns null for adhan when kSoundFilesPresent is false', () {
      // null tells Android to use the channel/system default sound.
      expect(
        NotificationSoundConfig.androidSound(NotificationSoundType.adhan),
        isNull,
        reason: 'Must fall back to system default when MP3 not present',
      );
    });

    test('androidSound returns null for iftarAdhan when kSoundFilesPresent is false', () {
      expect(
        NotificationSoundConfig.androidSound(NotificationSoundType.iftarAdhan),
        isNull,
      );
    });

    test('androidSound returns null for quranReminder when kSoundFilesPresent is false', () {
      expect(
        NotificationSoundConfig.androidSound(NotificationSoundType.quranReminder),
        isNull,
      );
    });

    test('androidSound always returns null for habitReminder (system default)', () {
      expect(
        NotificationSoundConfig.androidSound(NotificationSoundType.habitReminder),
        isNull,
      );
    });

    test('androidSound always returns null for generalReminder (system default)', () {
      expect(
        NotificationSoundConfig.androidSound(NotificationSoundType.generalReminder),
        isNull,
      );
    });
  });

  // ── NotificationSoundConfig.iosSound ────────────────────────────────────────

  group('NotificationSoundConfig.iosSound', () {
    // iOS resolves sound files at runtime; a missing AIFF file is silently
    // ignored and the system default is used — so returning filenames is safe.
    test('adhan returns "adhan.aiff"', () {
      expect(NotificationSoundConfig.iosSound(NotificationSoundType.adhan), 'adhan.aiff');
    });

    test('iftarAdhan returns "iftar_adhan.aiff"', () {
      expect(
          NotificationSoundConfig.iosSound(NotificationSoundType.iftarAdhan),
          'iftar_adhan.aiff');
    });

    test('quranReminder returns "quran_reminder.aiff"', () {
      expect(
          NotificationSoundConfig.iosSound(NotificationSoundType.quranReminder),
          'quran_reminder.aiff');
    });

    test('habitReminder returns null', () {
      expect(NotificationSoundConfig.iosSound(NotificationSoundType.habitReminder), isNull);
    });

    test('generalReminder returns null', () {
      expect(NotificationSoundConfig.iosSound(NotificationSoundType.generalReminder), isNull);
    });
  });

  // ── NotificationSoundConfig.iosThreadId ─────────────────────────────────────

  group('NotificationSoundConfig.iosThreadId', () {
    test('adhan → "prayer_adhan"', () {
      expect(
          NotificationSoundConfig.iosThreadId(NotificationSoundType.adhan),
          'prayer_adhan');
    });

    test('iftarAdhan → "iftar_adhan"', () {
      expect(
          NotificationSoundConfig.iosThreadId(NotificationSoundType.iftarAdhan),
          'iftar_adhan');
    });

    test('quranReminder → "quran"', () {
      expect(
          NotificationSoundConfig.iosThreadId(NotificationSoundType.quranReminder),
          'quran');
    });

    test('habitReminder → "habit"', () {
      expect(
          NotificationSoundConfig.iosThreadId(NotificationSoundType.habitReminder),
          'habit');
    });

    test('generalReminder → "general"', () {
      expect(
          NotificationSoundConfig.iosThreadId(NotificationSoundType.generalReminder),
          'general');
    });

    test('all 5 thread IDs are unique', () {
      final ids = NotificationSoundType.values
          .map(NotificationSoundConfig.iosThreadId)
          .toList();
      expect(ids.toSet().length, ids.length);
    });
  });

  // ── NotificationSoundConfig.playSound ───────────────────────────────────────

  group('NotificationSoundConfig.playSound', () {
    test('all types play sound (custom file or system default)', () {
      for (final type in NotificationSoundType.values) {
        expect(
          NotificationSoundConfig.playSound(type),
          isTrue,
          reason: '$type must always play some sound',
        );
      }
    });
  });
}
