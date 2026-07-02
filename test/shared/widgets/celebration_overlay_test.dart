import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:productive_muslim/shared/widgets/celebration_overlay.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  // ── FullScreenCelebrationOverlay — rendering ──────────────────────────────

  group('FullScreenCelebrationOverlay — rendering', () {
    testWidgets('shows habit name', (tester) async {
      await tester.pumpWidget(_wrap(FullScreenCelebrationOverlay(
        habitName: 'Fajr Prayer',
        streakCount: 7,
        onDismiss: () {},
      )));
      await tester.pump();
      expect(find.text('Fajr Prayer'), findsOneWidget);
    });

    testWidgets('shows streak count', (tester) async {
      await tester.pumpWidget(_wrap(FullScreenCelebrationOverlay(
        habitName: 'Quran',
        streakCount: 30,
        onDismiss: () {},
      )));
      await tester.pump();
      expect(find.textContaining('30'), findsOneWidget);
    });

    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(_wrap(FullScreenCelebrationOverlay(
        habitName: 'Dhikr',
        streakCount: 1,
        onDismiss: () {},
      )));
      await tester.pump();
    });
  });

  // ── FullScreenCelebrationOverlay — auto-dismiss ───────────────────────────

  group('FullScreenCelebrationOverlay — auto-dismiss', () {
    testWidgets('auto-dismisses after 2500ms', (tester) async {
      bool dismissed = false;
      await tester.pumpWidget(_wrap(FullScreenCelebrationOverlay(
        habitName: 'Fajr',
        streakCount: 7,
        onDismiss: () => dismissed = true,
      )));
      await tester.pump(const Duration(milliseconds: 2500));
      await tester.pumpAndSettle();
      expect(dismissed, isTrue);
    });

    testWidgets('onDismiss NOT called before 2500ms', (tester) async {
      bool dismissed = false;
      await tester.pumpWidget(_wrap(FullScreenCelebrationOverlay(
        habitName: 'Fajr',
        streakCount: 7,
        onDismiss: () => dismissed = true,
      )));
      // Pump only 1 second — well before auto-dismiss
      await tester.pump(const Duration(milliseconds: 1000));
      expect(dismissed, isFalse);
      // Let remaining timers/animations complete to avoid pending-timer warnings
      await tester.pumpAndSettle();
    });

    testWidgets('onDismiss called exactly once', (tester) async {
      int callCount = 0;
      await tester.pumpWidget(_wrap(FullScreenCelebrationOverlay(
        habitName: 'Fajr',
        streakCount: 7,
        onDismiss: () => callCount++,
      )));
      await tester.pump(const Duration(milliseconds: 2500));
      await tester.pumpAndSettle();
      expect(callCount, 1);
    });
  });
}
