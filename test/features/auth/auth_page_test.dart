import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:productive_muslim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:productive_muslim/features/auth/presentation/pages/auth_page.dart';
import 'package:productive_muslim/features/auth/presentation/widgets/auth_widgets.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

Widget _buildPage(AuthBloc bloc) {
  return MaterialApp(
    home: BlocProvider<AuthBloc>.value(
      value: bloc,
      child: const AuthPage(),
    ),
  );
}

void main() {
  late MockAuthBloc authBloc;

  setUp(() {
    authBloc = MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthInitial());
    whenListen(
      authBloc,
      Stream<AuthState>.fromIterable([const AuthInitial()]),
      initialState: const AuthInitial(),
    );
  });

  // ── AuthPage rendering ───────────────────────────────────────────────────────

  group('AuthPage — rendering', () {
    testWidgets('renders "PM" logo text', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      expect(find.text('PM'), findsOneWidget);
    });

    testWidgets('renders app name "Productive Muslim"', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      expect(find.text('Productive Muslim'), findsOneWidget);
    });

    testWidgets('renders GoogleSignInButton', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      expect(find.byType(GoogleSignInButton), findsOneWidget);
    });

    testWidgets('renders "Continue with Google" text', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('renders OrDivider', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      expect(find.byType(OrDivider), findsOneWidget);
    });

    testWidgets('renders "Continue as Guest" button', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      expect(find.text('Continue as Guest'), findsOneWidget);
    });
  });

  // ── AuthPage — event dispatch ────────────────────────────────────────────────

  group('AuthPage — event dispatch', () {
    testWidgets('tapping Google button dispatches AuthSignInRequested', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      await tester.tap(find.byType(GoogleSignInButton));
      verify(() => authBloc.add(const AuthSignInRequested())).called(1);
    });

    testWidgets('tapping "Continue as Guest" dispatches AuthGuestRequested', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      await tester.tap(find.text('Continue as Guest'));
      verify(() => authBloc.add(const AuthGuestRequested())).called(1);
    });
  });

  // ── AuthPage — loading state ─────────────────────────────────────────────────

  group('AuthPage — AuthLoading state', () {
    setUp(() {
      when(() => authBloc.state).thenReturn(const AuthLoading());
      whenListen(
        authBloc,
        Stream<AuthState>.fromIterable([const AuthLoading()]),
        initialState: const AuthLoading(),
      );
    });

    testWidgets('shows "Signing in..." text on GoogleSignInButton', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      expect(find.text('Signing in...'), findsOneWidget);
    });

    testWidgets('GoogleSignInButton shows CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('"Continue as Guest" is disabled (onPressed null) during loading',
        (tester) async {
      await tester.pumpWidget(_buildPage(authBloc));
      await tester.pump();
      final button = tester.widget<TextButton>(find.widgetWithText(TextButton, 'Continue as Guest'));
      expect(button.onPressed, isNull);
    });
  });

  // ── GoogleSignInButton standalone ────────────────────────────────────────────

  group('GoogleSignInButton', () {
    testWidgets('renders "Continue with Google" by default', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: GoogleSignInButton(onTap: () {})),
      ));
      await tester.pump();
      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('isLoading shows "Signing in..." text', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: GoogleSignInButton(onTap: () {}, isLoading: true)),
      ));
      await tester.pump();
      expect(find.text('Signing in...'), findsOneWidget);
    });

    testWidgets('isLoading shows CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: GoogleSignInButton(onTap: () {}, isLoading: true)),
      ));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('onTap callback fires when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: GoogleSignInButton(onTap: () => tapped = true)),
      ));
      await tester.pump();
      await tester.tap(find.byType(GoogleSignInButton));
      expect(tapped, isTrue);
    });

    testWidgets('onTap is NOT invoked when isLoading = true', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: GoogleSignInButton(onTap: () => tapped = true, isLoading: true)),
      ));
      await tester.pump();
      await tester.tap(find.byType(GoogleSignInButton));
      expect(tapped, isFalse);
    });
  });

  // ── OrDivider ─────────────────────────────────────────────────────────────────

  group('OrDivider', () {
    testWidgets('renders "or" text', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: OrDivider()),
      ));
      await tester.pump();
      expect(find.text('or'), findsOneWidget);
    });

    testWidgets('contains two Divider widgets', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: OrDivider()),
      ));
      await tester.pump();
      expect(find.byType(Divider), findsNWidgets(2));
    });
  });
}
