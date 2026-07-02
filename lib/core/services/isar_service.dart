import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/onboarding/data/models/user_profile_model.dart';
import '../../features/prayer/data/models/cached_prayer_day_model.dart';
import '../../features/timeline/data/models/time_block_model.dart';
import '../../features/timeline/data/models/daily_timeline_model.dart';
import '../../features/habits/data/models/habit_model.dart';
import '../../features/ramadan/data/models/ramadan_profile_model.dart';

class IsarService {
  static Isar? _instance;

  static Future<Isar> get instance async {
    _instance ??= await _openIsar();
    return _instance!;
  }

  static Future<Isar> _openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [
        UserProfileModelSchema,
        CachedPrayerDayModelSchema,
        TimeBlockModelSchema,
        DailyTimelineModelSchema,
        HabitModelSchema,
        StreakRecordModelSchema,
        RamadanProfileModelSchema,
      ],
      directory: dir.path,
      name: 'productive_muslim_db',
    );
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
