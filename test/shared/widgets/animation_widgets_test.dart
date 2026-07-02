import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:productive_muslim/shared/widgets/celebration_overlay.dart';
import 'package:productive_muslim/shared/widgets/app_splash_screen.dart';
import 'package:productive_muslim/features/timeline/domain/entities/time_block.dart';
import 'package:productive_muslim/features/timeline/presentation/widgets/timeline_widgets.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

TimeBlock _block({
  bool isCompleted = false,
  bool isSkipped = false,
  TimeBlockType type = TimeBlockType.work,
  BlockPriority priority = BlockPriority.fixed,
  String title = 'Morning Work',
}) {
  final base = DateTime(2026, 1, 1, 9, 0);
  return TimeBlock(
    id: 'test-block',
    type: type,
    startTime: base,
    endTime: base.add(const Duration(hours: 1)),
    title: title,
    priority: priority,
    isCompleted: isCompleted,
    isSkipped: isSkipped,
  );
}

Widget _materialWrap(Widget child) =>
    MaterialApp(home: Scaffold(body: child));

Widget _overlayWrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Builder(builder: (_) => child)));

GoRouter _splashRouter({String target = '/done'}) => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => AppSplashScreen(targetRoute: target),
        ),
        GoRoute(
          path: '/done',
          builder: (_, __) => const Scaffold(body: SizedBox()),
        ),
      ],
    );

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  // ── Celebration overlay ───────────────────────────────────────────────────

  group('FullScreenCelebrationOverlay', () {
    Future<void> showOverlay(
      WidgetTester tester, {
      String habitName = 'Fajr Prayer',
      int streakCount = 30,
    }) async {
      await tester.pumpWidget(_overlayWrap(
        Builder(builder: (ctx) => ElevatedButton(
              onPressed: () => FullScreenCelebrationOverlay.show(
                ctx,
                habitName: habitName,
                streakCount: streakCount,
              ),
              child: const Text('show'),
            )),
      ));
      await tester.tap(find.text('show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }

    testWidgets('renders habit name', (tester) async {
      await showOverlay(tester, habitName: 'Fajr Prayer');
      expect(find.text('Fajr Prayer'), findsOneWidget);
    });

    testWidgets('renders streak count', (tester) async {
      await showOverlay(tester, streakCount: 15);
      expect(find.textContaining('15 day streak'), findsOneWidget);
    });

    testWidgets('contains trophy emoji', (tester) async {
      await showOverlay(tester);
      expect(find.text('🏆'), findsOneWidget);
    });

    testWidgets('displays New Personal Best headline', (tester) async {
      await showOverlay(tester);
      expect(find.text('New Personal Best!'), findsOneWidget);
    });

    testWidgets('shows dismiss hint', (tester) async {
      await showOverlay(tester);
      expect(find.text('Tap anywhere to dismiss'), findsOneWidget);
    });

    testWidgets('contains confetti CustomPaint', (tester) async {
      await showOverlay(tester);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  // ── AppSplashScreen ───────────────────────────────────────────────────────

  group('AppSplashScreen', () {
    testWidgets('renders app name', (tester) async {
      await tester.pumpWidget(
          MaterialApp.router(routerConfig: _splashRouter()));
      await tester.pump();
      expect(find.text('Productive Muslim'), findsOneWidget);
    });

    testWidgets('renders tagline', (tester) async {
      await tester.pumpWidget(
          MaterialApp.router(routerConfig: _splashRouter()));
      await tester.pump();
      expect(find.text('Balance. Worship. Grow.'), findsOneWidget);
    });

    testWidgets('contains CustomPaint for geometric pattern', (tester) async {
      await tester.pumpWidget(
          MaterialApp.router(routerConfig: _splashRouter()));
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('navigates away after animation completes', (tester) async {
      await tester.pumpWidget(
          MaterialApp.router(routerConfig: _splashRouter(target: '/done')));
      // logo 900ms + hold 1600ms = 2500ms
      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pumpAndSettle();
      expect(find.text('Productive Muslim'), findsNothing);
    });

    testWidgets('renders Arabic subtitle "المسلم المنتج"', (tester) async {
      await tester.pumpWidget(
          MaterialApp.router(routerConfig: _splashRouter()));
      // Arabic subtitle fades in at 900-1300ms
      await tester.pump(const Duration(milliseconds: 1400));
      expect(find.text('المسلم المنتج'), findsOneWidget);
    });

    testWidgets('tablet layout — renders without overflow at 800×1024',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1024));
      addTearDown(() async =>
          tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
          MaterialApp.router(routerConfig: _splashRouter()));
      await tester.pump();
      expect(find.text('Productive Muslim'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tablet layout — tagline renders at 800×1024', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1024));
      addTearDown(() async =>
          tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
          MaterialApp.router(routerConfig: _splashRouter()));
      await tester.pump();
      expect(find.text('Balance. Worship. Grow.'), findsOneWidget);
    });
  });

  // ── TimeBlockCard ─────────────────────────────────────────────────────────

  group('TimeBlockCard', () {
    testWidgets('renders block title', (tester) async {
      await tester.pumpWidget(
          _materialWrap(TimeBlockCard(block: _block(title: 'Deep Work'))));
      await tester.pump();
      expect(find.text('Deep Work'), findsOneWidget);
    });

    testWidgets('renders emoji for quran block type', (tester) async {
      await tester.pumpWidget(_materialWrap(
        TimeBlockCard(
            block: _block(
                type: TimeBlockType.quran,
                priority: BlockPriority.important)),
      ));
      await tester.pump();
      expect(find.text('📖'), findsOneWidget);
    });

    testWidgets('shows check icon when completed', (tester) async {
      await tester.pumpWidget(
          _materialWrap(TimeBlockCard(block: _block(isCompleted: true))));
      await tester.pump();
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('ScaleTransition wraps check icon when completed',
        (tester) async {
      await tester.pumpWidget(
          _materialWrap(TimeBlockCard(block: _block(isCompleted: true))));
      await tester.pump();
      // MaterialApp introduces its own ScaleTransition for page transitions,
      // so search specifically for the one that wraps the check icon.
      final scaleTransition = find.ancestor(
        of: find.byIcon(Icons.check_circle),
        matching: find.byType(ScaleTransition),
      );
      expect(scaleTransition, findsOneWidget);
    });

    testWidgets('no check icon when not completed', (tester) async {
      await tester.pumpWidget(
          _materialWrap(TimeBlockCard(block: _block(isCompleted: false))));
      await tester.pump();
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('check icon animates in after state changes to completed',
        (tester) async {
      await tester.pumpWidget(
          _materialWrap(TimeBlockCard(block: _block(isCompleted: false))));
      await tester.pump();
      expect(find.byIcon(Icons.check_circle), findsNothing);

      await tester.pumpWidget(
          _materialWrap(TimeBlockCard(block: _block(isCompleted: true))));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows NOW badge when isCurrentBlock', (tester) async {
      await tester.pumpWidget(_materialWrap(
          TimeBlockCard(block: _block(), isCurrentBlock: true)));
      await tester.pump();
      expect(find.text('NOW'), findsOneWidget);
    });

    testWidgets('hides NOW badge when not current block', (tester) async {
      await tester.pumpWidget(_materialWrap(
          TimeBlockCard(block: _block(), isCurrentBlock: false)));
      await tester.pump();
      expect(find.text('NOW'), findsNothing);
    });
  });
}
