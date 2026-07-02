# Phase 2 — Isar Code Generation

After adding Phase 2 files, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This will generate `.g.dart` files for:
- `lib/features/onboarding/data/models/user_profile_model.dart`
- `lib/features/timeline/data/models/time_block_model.dart`
- `lib/features/timeline/data/models/daily_timeline_model.dart`

## Watch mode (during development)
```bash
dart run build_runner watch --delete-conflicting-outputs
```

Do NOT manually edit `.g.dart` files — they are fully auto-generated.
