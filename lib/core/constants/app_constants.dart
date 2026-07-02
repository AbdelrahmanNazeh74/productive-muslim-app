// ─── OCCUPATION CONSTANTS ────────────────────────────────────────────────────
class OccupationConstants {
  OccupationConstants._();

  static const List<Map<String, dynamic>> occupations = [
    {
      'id': 'software_engineer',
      'label': 'Software Engineer',
      'emoji': '💻',
      'type': 'office',
    },
    {
      'id': 'student',
      'label': 'Student',
      'emoji': '📚',
      'type': 'student',
    },
    {
      'id': 'doctor',
      'label': 'Doctor / Medical',
      'emoji': '🏥',
      'type': 'shift',
    },
    {
      'id': 'teacher',
      'label': 'Teacher / Educator',
      'emoji': '🎓',
      'type': 'office',
    },
    {
      'id': 'engineer',
      'label': 'Engineer (Non-Software)',
      'emoji': '⚙️',
      'type': 'office',
    },
    {
      'id': 'accountant',
      'label': 'Accountant / Finance',
      'emoji': '📊',
      'type': 'office',
    },
    {
      'id': 'freelancer',
      'label': 'Freelancer / Self-Employed',
      'emoji': '🚀',
      'type': 'remote',
    },
    {
      'id': 'business_owner',
      'label': 'Business Owner',
      'emoji': '🏢',
      'type': 'remote',
    },
    {
      'id': 'homemaker',
      'label': 'Homemaker',
      'emoji': '🏠',
      'type': 'home',
    },
    {
      'id': 'lawyer',
      'label': 'Lawyer / Legal',
      'emoji': '⚖️',
      'type': 'office',
    },
    {
      'id': 'designer',
      'label': 'Designer / Creative',
      'emoji': '🎨',
      'type': 'remote',
    },
    {
      'id': 'other',
      'label': 'Other',
      'emoji': '✨',
      'type': 'office',
    },
  ];
}

// ─── PRAYER CALCULATION METHODS ──────────────────────────────────────────────
class PrayerCalculationMethods {
  PrayerCalculationMethods._();

  static const List<Map<String, String>> methods = [
    {
      'id': 'MuslimWorldLeague',
      'label': 'Muslim World League (MWL)',
      'region': 'Europe, Far East, parts of America',
    },
    {
      'id': 'Egyptian',
      'label': 'Egyptian General Authority',
      'region': 'Africa, Syria, Lebanon, Malaysia',
    },
    {
      'id': 'Karachi',
      'label': 'University of Islamic Sciences, Karachi',
      'region': 'Pakistan, Bangladesh, India, Afghanistan',
    },
    {
      'id': 'UmmAlQura',
      'label': 'Umm Al-Qura University, Makkah',
      'region': 'Saudi Arabia (Recommended)',
    },
    {
      'id': 'Dubai',
      'label': 'Dubai',
      'region': 'UAE',
    },
    {
      'id': 'Kuwait',
      'label': 'Kuwait',
      'region': 'Kuwait',
    },
    {
      'id': 'Qatar',
      'label': 'Qatar',
      'region': 'Qatar',
    },
    {
      'id': 'Singapore',
      'label': 'Majlis Ugama Islam Singapura',
      'region': 'Singapore',
    },
    {
      'id': 'NorthAmerica',
      'label': 'Islamic Society of North America (ISNA)',
      'region': 'North America',
    },
    {
      'id': 'Turkey',
      'label': 'Diyanet İşleri Başkanlığı',
      'region': 'Turkey',
    },
  ];
}

// ─── FITNESS CONSTANTS ────────────────────────────────────────────────────────
class FitnessConstants {
  FitnessConstants._();

  static const List<Map<String, String>> activities = [
    {'id': 'gym', 'label': 'Gym / Weight Training', 'emoji': '🏋️'},
    {'id': 'running', 'label': 'Running / Jogging', 'emoji': '🏃'},
    {'id': 'cycling', 'label': 'Cycling', 'emoji': '🚴'},
    {'id': 'swimming', 'label': 'Swimming', 'emoji': '🏊'},
    {'id': 'football', 'label': 'Football / Soccer', 'emoji': '⚽'},
    {'id': 'basketball', 'label': 'Basketball', 'emoji': '🏀'},
    {'id': 'martial_arts', 'label': 'Martial Arts', 'emoji': '🥋'},
    {'id': 'yoga', 'label': 'Yoga / Stretching', 'emoji': '🧘'},
    {'id': 'walking', 'label': 'Daily Walking', 'emoji': '🚶'},
    {'id': 'home_workout', 'label': 'Home Workout', 'emoji': '🏠'},
    {'id': 'none', 'label': 'No Regular Exercise', 'emoji': '😴'},
  ];

  static const List<Map<String, dynamic>> durations = [
    {'id': 30, 'label': '30 minutes'},
    {'id': 45, 'label': '45 minutes'},
    {'id': 60, 'label': '1 hour'},
    {'id': 90, 'label': '1.5 hours'},
    {'id': 120, 'label': '2 hours'},
  ];

  static const List<Map<String, String>> preferredTimes = [
    {'id': 'post_fajr', 'label': 'After Fajr', 'emoji': '🌅'},
    {'id': 'morning', 'label': 'Morning (7–10 AM)', 'emoji': '☀️'},
    {'id': 'midday', 'label': 'Midday (11 AM–1 PM)', 'emoji': '🌤'},
    {'id': 'evening', 'label': 'Evening (4–7 PM)', 'emoji': '🌆'},
    {'id': 'night', 'label': 'Night (After Isha)', 'emoji': '🌙'},
  ];

  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}

// ─── SLEEP CONSTANTS ──────────────────────────────────────────────────────────
class SleepConstants {
  SleepConstants._();

  static const List<Map<String, dynamic>> targetHours = [
    {'id': 6, 'label': '6 hours'},
    {'id': 7, 'label': '7 hours (recommended)'},
    {'id': 8, 'label': '8 hours'},
    {'id': 9, 'label': '9 hours'},
  ];

  static const List<Map<String, dynamic>> fajrOffsets = [
    {'id': 0, 'label': 'Exactly at Fajr'},
    {'id': -15, 'label': '15 min before Fajr'},
    {'id': -30, 'label': '30 min before Fajr'},
    {'id': -45, 'label': '45 min before Fajr'},
    {'id': 15, 'label': '15 min after Fajr'},
    {'id': 30, 'label': '30 min after Fajr'},
  ];
}

// ─── MADHAB CONSTANTS ─────────────────────────────────────────────────────────
class MadhabConstants {
  MadhabConstants._();

  static const List<Map<String, String>> madhhabs = [
    {
      'id': 'shafi',
      'label': 'Shafi\'i / Maliki / Hanbali',
      'description': 'Asr: Shadow = object length',
    },
    {
      'id': 'hanafi',
      'label': 'Hanafi',
      'description': 'Asr: Shadow = 2× object length',
    },
  ];
}

// ─── ONBOARDING STEPS ─────────────────────────────────────────────────────────
class OnboardingSteps {
  OnboardingSteps._();

  static const int totalSteps = 6;

  static const List<Map<String, String>> steps = [
    {
      'title': 'Welcome',
      'subtitle': 'Let\'s personalize your journey',
    },
    {
      'title': 'Your Occupation',
      'subtitle': 'Tell us what you do',
    },
    {
      'title': 'Work Schedule',
      'subtitle': 'When do you work or study?',
    },
    {
      'title': 'Prayer Settings',
      'subtitle': 'Configure your prayer times',
    },
    {
      'title': 'Fitness Goals',
      'subtitle': 'Plan your health routine',
    },
    {
      'title': 'Sleep & Rest',
      'subtitle': 'Optimize your sleep around Fajr',
    },
  ];
}
