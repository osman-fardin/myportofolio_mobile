import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:myportofolio_mobile/widgets/portfolio_sections.dart';

void main() {
  testWidgets('Home page displays the owner profile and welcome message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(
      find.widgetWithText(AppBar, 'Muhammad Osman Fardin'),
      findsOneWidget,
    );
    expect(find.text("Hi, I'm Fardin."), findsOneWidget);
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
    (size: const Size(320, 568), scale: 1.0, stacked: true),
    (size: const Size(390, 844), scale: 1.0, stacked: true),
    (size: const Size(1280, 720), scale: 1.0, stacked: false),
    (size: const Size(320, 240), scale: 2.0, stacked: true),
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
        final welcome = find.text("Hi, I'm Fardin.");
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
        final firstCard = tester.getRect(
          find.widgetWithText(ItemCard, 'Lihat Proyek'),
        );
        final lastCard = tester.getRect(
          find.widgetWithText(ItemCard, 'Logout'),
        );
        if (viewport.stacked) {
          expect(lastCard.top, greaterThan(firstCard.bottom));
          expect(lastCard.left, firstCard.left);
        } else {
          expect(lastCard.top, firstCard.top);
          expect(lastCard.left, greaterThan(firstCard.right));
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final name in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
    testWidgets('$name displays its own SnackBar message', (tester) async {
      await tester.pumpWidget(const MyApp());

      final card = find.widgetWithText(ItemCard, name);
      expect(card, findsOneWidget);
      await tester.ensureVisible(card);
      await tester.pumpAndSettle();
      await tester.tap(card);
      await tester.pumpAndSettle();

      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
      if (name == 'Tambah Proyek') {
        expect(find.byType(ProjectFormPage), findsOneWidget);
      } else {
        expect(
          find.widgetWithText(AppBar, 'Muhammad Osman Fardin'),
          findsOneWidget,
        );
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Rapid taps replace earlier messages without leaving a queue', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Logout'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();

    expect(
      find.text('Kamu telah menekan tombol Lihat Proyek!'),
      findsOneWidget,
    );
    expect(find.text('Kamu telah menekan tombol Logout!'), findsNothing);
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
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    final focusedCard = tester.getRect(
      find.widgetWithText(ItemCard, 'Lihat Proyek'),
    );
    expect(focusedCard.top, greaterThanOrEqualTo(64));
    expect(focusedCard.bottom, lessThanOrEqualTo(600));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(
      find.text('Kamu telah menekan tombol Lihat Proyek!'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('About content and footer are reachable on a small screen', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.byType(PortfolioAbout));
    await tester.pumpAndSettle();

    expect(find.text('About me'), findsOneWidget);
    expect(find.bySemanticsLabel('Foto Muhammad Osman Fardin'), findsOneWidget);
    expect(
      find.text('S1 Ilmu Komputer · Universitas Indonesia'),
      findsOneWidget,
    );

    final footer = find.text(
      '© 2026 Muhammad Osman Fardin.\n'
      'Fakultas Ilmu Komputer, Universitas Indonesia.',
    );
    await tester.ensureVisible(footer);
    await tester.pumpAndSettle();
    final bounds = tester.getRect(footer);
    expect(bounds.left, greaterThanOrEqualTo(0));
    expect(bounds.right, lessThanOrEqualTo(390));
    expect(bounds.top, greaterThanOrEqualTo(64));
    expect(bounds.bottom, lessThanOrEqualTo(844));
    expect(tester.takeException(), isNull);
  });
}
