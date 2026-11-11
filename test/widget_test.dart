import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  testWidgets('Home page displays the owner profile and welcome message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
    for (final entry in {
      'NPM': '2506541723',
      'Name': 'Muhammad Osman Fardin',
      'Class': 'PBP D',
    }.entries) {
      final card = find.widgetWithText(InfoCard, entry.key);
      expect(card, findsOneWidget);
      expect(
        find.descendant(of: card, matching: find.text(entry.value)),
        findsOneWidget,
      );
    }
    expect(find.text('Burhan'), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'InfoCard displays the title and content supplied by its caller',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoCard(title: 'Label uji', content: 'Konten uji'),
          ),
        ),
      );

      expect(find.text('Label uji'), findsOneWidget);
      expect(find.text('Konten uji'), findsOneWidget);
      expect(find.text('Muhammad Osman Fardin'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  for (final viewport in [
    (size: const Size(320, 568), scale: 1.0),
    (size: const Size(390, 844), scale: 1.0),
    (size: const Size(1280, 720), scale: 1.0),
    (size: const Size(320, 240), scale: 2.0),
  ]) {
    testWidgets(
      'Profile and actions remain readable at ${viewport.size}, scale ${viewport.scale}',
      (WidgetTester tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = viewport.size;
        tester.platformDispatcher.textScaleFactorTestValue = viewport.scale;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.pumpWidget(const MyApp());
        final welcome = find.text('Selamat datang di MyPortfolio Mobile!');
        await tester.ensureVisible(welcome);
        await tester.pumpAndSettle();
        final bounds = tester.getRect(welcome);
        expect(bounds.left, greaterThanOrEqualTo(0));
        expect(bounds.right, lessThanOrEqualTo(viewport.size.width));
        expect(bounds.top, greaterThanOrEqualTo(0));

        final lastAction = find.text('Logout');
        await tester.ensureVisible(lastAction);
        await tester.pumpAndSettle();
        final lastActionBounds = tester.getRect(lastAction);
        expect(lastActionBounds.left, greaterThanOrEqualTo(0));
        expect(lastActionBounds.right, lessThanOrEqualTo(viewport.size.width));
        expect(lastActionBounds.top, greaterThanOrEqualTo(0));
        expect(
          lastActionBounds.bottom,
          lessThanOrEqualTo(viewport.size.height),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final name in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
    testWidgets('$name displays its own SnackBar message', (tester) async {
      await tester.pumpWidget(const MyApp());

      final card = find.widgetWithText(ItemCard, name);
      expect(card, findsOneWidget);
      await tester.tap(card);
      await tester.pumpAndSettle();

      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
      expect(find.text('MyPortfolio'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Rapid taps replace earlier messages without leaving a queue', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
    expect(find.text('Kamu telah menekan tombol Lihat Proyek!'), findsNothing);
    expect(find.text('Kamu telah menekan tombol Tambah Proyek!'), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Keyboard users can activate the first action', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(
      find.text('Kamu telah menekan tombol Lihat Proyek!'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
