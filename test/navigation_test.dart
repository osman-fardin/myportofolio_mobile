import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

Future<void> openDrawer(WidgetTester tester) async {
  await tester.tap(find.byType(DrawerButton));
  await tester.pumpAndSettle();
}

Future<void> chooseDestination(WidgetTester tester, String label) async {
  final tile = find.widgetWithText(ListTile, label);
  await tester.scrollUntilVisible(
    tile,
    180,
    scrollable: find.descendant(
      of: find.byType(LeftDrawer),
      matching: find.byType(Scrollable),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(tile);
  await tester.pumpAndSettle();
}

NavigatorState navigator(WidgetTester tester) =>
    tester.state<NavigatorState>(find.byType(Navigator));

void main() {
  testWidgets('Experience card pushes a form with Back and its own SnackBar', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final home = tester.element(find.byType(MyHomePage));
    final card = find.widgetWithText(ItemCard, 'Tambah Pengalaman');
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);
    expect(
      find.text('Kamu telah menekan tombol Tambah Pengalaman!'),
      findsOneWidget,
    );
    expect(navigator(tester).canPop(), isTrue);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(tester.element(find.byType(MyHomePage)), same(home));
  });

  testWidgets(
    'The shared drawer connects all three destinations and preserves an active Experience draft',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      for (final label in [
        'Tambah Pengalaman',
        'Tambah Proyek',
        'Tambah Pengalaman',
      ]) {
        await openDrawer(tester);
        expect(find.widgetWithText(ListTile, 'Home'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Tambah Proyek'), findsOneWidget);
        expect(
          find.widgetWithText(ListTile, 'Tambah Pengalaman'),
          findsOneWidget,
        );
        await chooseDestination(tester, label);
        expect(navigator(tester).canPop(), isFalse);
      }
      final originalForm = tester.state(find.byType(ExperienceFormPage));
      await tester.enterText(
        find.byKey(const ValueKey('experience-title')),
        'Draft pengalaman',
      );
      await openDrawer(tester);
      await chooseDestination(tester, 'Tambah Pengalaman');
      expect(tester.state(find.byType(ExperienceFormPage)), same(originalForm));
      expect(find.text('Draft pengalaman'), findsOneWidget);
      await openDrawer(tester);
      await chooseDestination(tester, 'Home');
      expect(find.byType(MyHomePage), findsOneWidget);
      expect(
        find.byType(ExperienceFormPage, skipOffstage: false),
        findsNothing,
      );
      expect(navigator(tester).canPop(), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Experience drawer remains reachable at 320px with 200% text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const MyApp());
    await openDrawer(tester);
    await chooseDestination(tester, 'Tambah Pengalaman');
    expect(find.byType(ExperienceFormPage), findsOneWidget);
    await openDrawer(tester);
    await chooseDestination(tester, 'Home');
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Add card pushes a form; Back returns to the same Home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final originalHome = tester.element(find.byType(MyHomePage));
    final card = find.widgetWithText(ItemCard, 'Tambah Proyek');
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(
      find.text('Kamu telah menekan tombol Tambah Proyek!'),
      findsOneWidget,
    );
    expect(navigator(tester).canPop(), isTrue);
    expect(find.byType(BackButton), findsOneWidget);
    expect(find.byType(DrawerButton), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(tester.element(find.byType(MyHomePage)), same(originalHome));
    expect(navigator(tester).canPop(), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Drawer replaces root destinations without building a history stack',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      for (var cycle = 0; cycle < 3; cycle++) {
        await openDrawer(tester);
        expect(find.text('MyPortfolio'), findsOneWidget);
        expect(find.text('2506541723 · PBP D'), findsOneWidget);
        expect(
          tester
              .widget<ListTile>(find.widgetWithText(ListTile, 'Home'))
              .selected,
          isTrue,
        );
        await chooseDestination(tester, 'Tambah Proyek');
        expect(find.byType(ProjectFormPage), findsOneWidget);
        expect(find.byType(MyHomePage, skipOffstage: false), findsNothing);
        expect(navigator(tester).canPop(), isFalse);
        expect(find.byType(BackButton), findsNothing);
        await openDrawer(tester);
        expect(
          tester
              .widget<ListTile>(find.widgetWithText(ListTile, 'Tambah Proyek'))
              .selected,
          isTrue,
        );
        await chooseDestination(tester, 'Home');
        expect(find.byType(MyHomePage), findsOneWidget);
        expect(find.byType(ProjectFormPage, skipOffstage: false), findsNothing);
        expect(navigator(tester).canPop(), isFalse);
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Selecting the current drawer destination preserves the page and form draft',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      final originalHome = tester.element(find.byType(MyHomePage));
      await openDrawer(tester);
      await chooseDestination(tester, 'Home');
      expect(tester.element(find.byType(MyHomePage)), same(originalHome));
      await openDrawer(tester);
      await chooseDestination(tester, 'Tambah Proyek');
      final originalForm = tester.state(find.byType(ProjectFormPage));
      await tester.enterText(
        find.byKey(const ValueKey('title')),
        'Draft proyek',
      );
      await openDrawer(tester);
      await chooseDestination(tester, 'Tambah Proyek');
      expect(tester.state(find.byType(ProjectFormPage)), same(originalForm));
      expect(find.text('Draft proyek'), findsOneWidget);
      expect(navigator(tester).canPop(), isFalse);
      expect(
        tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
        isFalse,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Drawer replacement after a push preserves the earlier Home route',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      final originalHome = tester.element(find.byType(MyHomePage));
      final card = find.widgetWithText(ItemCard, 'Tambah Proyek');
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();
      await openDrawer(tester);
      await chooseDestination(tester, 'Home');
      expect(find.byType(MyHomePage), findsOneWidget);
      expect(find.byType(ProjectFormPage, skipOffstage: false), findsNothing);
      expect(navigator(tester).canPop(), isTrue);
      expect(find.byType(SnackBar), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(MyHomePage)), same(originalHome));
      expect(navigator(tester).canPop(), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Drawer identity and destinations remain usable at 320px and 200% text',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(const MyApp());
      await openDrawer(tester);
      final heading = find.descendant(
        of: find.byType(LeftDrawer),
        matching: find.text('Muhammad Osman Fardin'),
      );
      final bounds = tester.getRect(heading);
      expect(bounds.left, greaterThanOrEqualTo(0));
      expect(bounds.right, lessThanOrEqualTo(320));
      await chooseDestination(tester, 'Tambah Proyek');
      expect(find.byType(ProjectFormPage), findsOneWidget);
      await openDrawer(tester);
      await chooseDestination(tester, 'Home');
      expect(find.byType(MyHomePage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
