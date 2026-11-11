import 'package:flutter/material.dart';
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
      'Profile remains readable at ${viewport.size}, scale ${viewport.scale}',
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
        expect(tester.getRect(welcome).top, greaterThanOrEqualTo(0));

        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -1000),
        );
        await tester.pumpAndSettle();

        final bounds = tester.getRect(welcome);
        expect(bounds.left, greaterThanOrEqualTo(0));
        expect(bounds.right, lessThanOrEqualTo(viewport.size.width));
        expect(bounds.bottom, lessThanOrEqualTo(viewport.size.height));
        expect(bounds.bottom, greaterThan(0));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
