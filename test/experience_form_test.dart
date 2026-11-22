import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';
import 'package:myportofolio_mobile/widgets/date_time_form_field.dart';

Finder textField(String name) => find.byKey(ValueKey('experience-$name'));
Finder dateField(String label) => find.byWidgetPredicate(
  (widget) => widget is DateTimeFormField && widget.label == label,
);
FormFieldState<DateTime> dateState(WidgetTester tester, String label) =>
    tester.state<FormFieldState<DateTime>>(dateField(label));

Future<void> openForm(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(theme: PortfolioTheme.light, home: const ExperienceFormPage()),
  );
}

Future<void> enter(WidgetTester tester, String name, String value) async {
  await tester.ensureVisible(textField(name));
  await tester.enterText(textField(name), value);
  await tester.pumpAndSettle();
}

Future<void> fillRequired(WidgetTester tester) async {
  await enter(tester, 'title', ' Teaching Assistant ');
  await enter(tester, 'description', ' Memandu praktikum.\nMenilai tugas. ');
}

Future<void> save(WidgetTester tester) async {
  final button = find.widgetWithText(ElevatedButton, 'Simpan');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> openDatePicker(WidgetTester tester, String label) async {
  final button = find.descendant(
    of: dateField(label),
    matching: find.byType(OutlinedButton),
  );
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
  expect(find.byType(DatePickerDialog), findsOneWidget);
}

Future<void> confirmDate(WidgetTester tester, DateTime value) async {
  await tester.tap(find.byIcon(Icons.edit_outlined));
  await tester.pumpAndSettle();
  final dialog = find.byType(DatePickerDialog);
  final locale = MaterialLocalizations.of(tester.element(dialog));
  await tester.enterText(
    find.descendant(of: dialog, matching: find.byType(TextField)),
    locale.formatCompactDate(value),
  );
  await tester.tap(find.text('Lanjut'));
  await tester.pumpAndSettle();
  expect(find.byType(TimePickerDialog), findsOneWidget);
}

Future<void> chooseDateTime(
  WidgetTester tester,
  String label,
  DateTime value,
) async {
  await openDatePicker(tester, label);
  await confirmDate(tester, value);
  await tester.tap(find.byIcon(Icons.keyboard_outlined));
  await tester.pumpAndSettle();
  final fields = find.descendant(
    of: find.byType(TimePickerDialog),
    matching: find.byType(TextField),
  );
  await tester.enterText(fields.at(0), value.hour.toString().padLeft(2, '0'));
  await tester.enterText(fields.at(1), value.minute.toString().padLeft(2, '0'));
  await tester.tap(find.text('Pilih'));
  await tester.pumpAndSettle();
  expect(dateState(tester, label).value, value);
}

Finder dialogText(String value) =>
    find.descendant(of: find.byType(AlertDialog), matching: find.text(value));

void main() {
  testWidgets('Required fields reject whitespace and block the summary', (
    tester,
  ) async {
    await openForm(tester);
    await enter(tester, 'title', '  ');
    await save(tester);
    expect(find.text('Judul pengalaman tidak boleh kosong.'), findsOneWidget);
    expect(
      find.text('Deskripsi pengalaman tidak boleh kosong.'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Form uses title limits and URL validation from the shared rules',
    (tester) async {
      await openForm(tester);
      await fillRequired(tester);
      await enter(tester, 'title', 'a' * 256);
      await enter(tester, 'thumbnail', 'javascript:alert(1)');
      await save(tester);
      expect(
        find.text('Judul pengalaman maksimal 255 karakter.'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Masukkan URL thumbnail lengkap dengan http:// atau https://.',
        ),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets(
    'Ongoing summary uses current draft; OK preserves input for correction',
    (tester) async {
      await openForm(tester);
      final initialStart = dateState(tester, 'Waktu mulai').value!;
      expect(
        initialStart.difference(DateTime.now()).inMinutes.abs(),
        lessThanOrEqualTo(1),
      );
      await fillRequired(tester);
      await save(tester);
      for (final value in [
        'Teaching Assistant',
        'Memandu praktikum.\nMenilai tugas.',
        'Full-Time',
        'Tidak diisi',
        'Masih berlangsung',
        formatLocalDateTime(initialStart),
      ]) {
        expect(dialogText(value), findsOneWidget);
      }
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      await enter(tester, 'title', 'Research Assistant');
      await save(tester);
      expect(dialogText('Research Assistant'), findsOneWidget);
      expect(dialogText('Teaching Assistant'), findsNothing);
      expect(dialogText('Memandu praktikum.\nMenilai tugas.'), findsOneWidget);
    },
  );

  testWidgets('Real date and time pickers populate all six summary fields', (
    tester,
  ) async {
    await openForm(tester);
    await fillRequired(tester);
    await enter(tester, 'thumbnail', ' https://example.com/photo.jpg ');
    final category = find.byKey(const ValueKey('experience-category'));
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Research').last);
    await tester.pumpAndSettle();
    final start = DateTime(2026, 11, 1, 9, 30);
    final end = DateTime(2026, 11, 22, 16, 45);
    await chooseDateTime(tester, 'Waktu mulai', start);
    await chooseDateTime(tester, 'Waktu selesai (opsional)', end);
    await save(tester);
    for (final value in [
      'Teaching Assistant',
      'Memandu praktikum.\nMenilai tugas.',
      'Research',
      'https://example.com/photo.jpg',
      formatLocalDateTime(start),
      formatLocalDateTime(end),
    ]) {
      expect(dialogText(value), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Cancelling either picker leaves the original timestamp and draft intact',
    (tester) async {
      await openForm(tester);
      await fillRequired(tester);
      final original = dateState(tester, 'Waktu mulai').value;
      await openDatePicker(tester, 'Waktu mulai');
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      expect(dateState(tester, 'Waktu mulai').value, original);
      await openDatePicker(tester, 'Waktu mulai');
      await confirmDate(tester, DateTime(2026, 10, 1));
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      expect(dateState(tester, 'Waktu mulai').value, original);
      expect(dateState(tester, 'Waktu selesai (opsional)').value, isNull);
      await save(tester);
      expect(dialogText('Teaching Assistant'), findsOneWidget);
      expect(dialogText(formatLocalDateTime(original!)), findsOneWidget);
    },
  );

  testWidgets(
    'End order is revalidated when start changes, including minutes on the same day',
    (tester) async {
      await openForm(tester);
      await fillRequired(tester);
      final start = DateTime(2026, 11, 22, 9, 30);
      await chooseDateTime(tester, 'Waktu mulai', start);
      await chooseDateTime(
        tester,
        'Waktu selesai (opsional)',
        start.add(const Duration(minutes: 1)),
      );
      await chooseDateTime(
        tester,
        'Waktu mulai',
        start.add(const Duration(minutes: 2)),
      );
      expect(
        find.text('Waktu selesai tidak boleh lebih awal dari waktu mulai.'),
        findsOneWidget,
      );
      await save(tester);
      expect(find.byType(AlertDialog), findsNothing);
      await chooseDateTime(tester, 'Waktu mulai', start);
      expect(
        find.text('Waktu selesai tidak boleh lebih awal dari waktu mulai.'),
        findsNothing,
      );
      await save(tester);
      expect(find.byType(AlertDialog), findsOneWidget);
    },
  );

  testWidgets(
    'Clearing an end returns to ongoing without clearing other input',
    (tester) async {
      await openForm(tester);
      await fillRequired(tester);
      final start = dateState(tester, 'Waktu mulai').value!;
      await chooseDateTime(
        tester,
        'Waktu selesai (opsional)',
        start.add(const Duration(days: 1)),
      );
      final clear = find.widgetWithText(TextButton, 'Hapus waktu selesai');
      await tester.ensureVisible(clear);
      await tester.tap(clear);
      await tester.pumpAndSettle();
      expect(dateState(tester, 'Waktu selesai (opsional)').value, isNull);
      await save(tester);
      expect(dialogText('Masih berlangsung'), findsOneWidget);
      expect(dialogText('Teaching Assistant'), findsOneWidget);
    },
  );

  testWidgets(
    'Changing category preserves text draft and selected model value',
    (tester) async {
      await openForm(tester);
      await fillRequired(tester);
      final category = find.byKey(const ValueKey('experience-category'));
      await tester.ensureVisible(category);
      await tester.tap(category);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Volunteer').last);
      await tester.pumpAndSettle();
      expect(tester.state<FormFieldState<String>>(category).value, 'volunteer');
      await save(tester);
      expect(dialogText('Volunteer'), findsOneWidget);
      expect(dialogText('Teaching Assistant'), findsOneWidget);
    },
  );

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'Form, validation errors, and long summary remain usable at 320px, scale $scale',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 568);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await openForm(tester);
        await save(tester);
        expect(
          find.text('Judul pengalaman tidak boleh kosong.'),
          findsOneWidget,
        );
        await fillRequired(tester);
        await enter(tester, 'description', 'Tanggung jawab pengalaman.\n' * 20);
        await save(tester);
        expect(find.byType(AlertDialog), findsOneWidget);
        final ok = find.widgetWithText(TextButton, 'OK');
        final bounds = tester.getRect(ok);
        expect(bounds.left, greaterThanOrEqualTo(0));
        expect(bounds.right, lessThanOrEqualTo(320));
        expect(bounds.bottom, lessThanOrEqualTo(568));
        await tester.tap(ok);
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Save remains reachable while the keyboard consumes phone height',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetViewInsets);
      await openForm(tester);
      await fillRequired(tester);
      final button = find.widgetWithText(ElevatedButton, 'Simpan');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      expect(tester.getRect(button).bottom, lessThanOrEqualTo(544));
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
