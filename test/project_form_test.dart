import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

import 'support/test_app.dart';

Finder field(String name) => find.byKey(ValueKey(name));

Future<void> openForm(WidgetTester tester) async {
  await tester.pumpWidget(testHarness(const ProjectFormPage()));
}

Future<void> enter(WidgetTester tester, String name, String value) async {
  await tester.ensureVisible(field(name));
  await tester.enterText(field(name), value);
  await tester.pumpAndSettle();
}

Future<void> preview(WidgetTester tester) async {
  final button = find.widgetWithText(ElevatedButton, 'Simpan proyek');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> fillRequired(
  WidgetTester tester, {
  String title = 'Study Hub',
}) async {
  await enter(tester, 'title', title);
  await enter(tester, 'role', 'Developer');
  await enter(tester, 'description', 'Portal belajar mahasiswa.');
  await enter(tester, 'technologies', 'Flutter\nDjango');
  await enter(tester, 'live_url', 'https://example.com/project');
}

Future<void> selectType(WidgetTester tester, String value) async {
  await tester.ensureVisible(field('project_type'));
  await tester.tap(field('project_type'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(value).last);
  await tester.pumpAndSettle();
}

String inputText(WidgetTester tester, String name) {
  return tester.widget<TextFormField>(field(name)).controller?.text ??
      tester
          .widget<EditableText>(
            find.descendant(
              of: field(name),
              matching: find.byType(EditableText),
            ),
          )
          .controller
          .text;
}

void main() {
  testWidgets(
    'Empty and whitespace input show required errors without a dialog',
    (tester) async {
      await openForm(tester);
      await enter(tester, 'title', '   ');
      await preview(tester);
      for (final label in [
        'Nama proyek',
        'Peran saya',
        'Deskripsi',
        'Teknologi',
        'URL proyek',
      ]) {
        expect(find.text('$label tidak boleh kosong.'), findsOneWidget);
      }
      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets('Dialog shows every saved value and OK resets fields and type', (
    tester,
  ) async {
    await openForm(tester);
    await fillRequired(tester, title: '  Study Hub  ');
    await selectType(tester, 'Lainnya');
    await enter(tester, 'custom_type', ' Community Study Platform ');
    await enter(tester, 'source_url', 'https://github.com/example/project');
    await enter(tester, 'thumbnail_path', 'img/study-hub.jpg');
    await enter(tester, 'display_order', '7');
    await preview(tester);

    final dialog = find.byType(AlertDialog);
    expect(dialog, findsOneWidget);
    for (final value in [
      'Study Hub',
      'Community Study Platform',
      'Developer',
      'Portal belajar mahasiswa.',
      'Flutter\nDjango',
      'https://example.com/project',
      'https://github.com/example/project',
      'img/study-hub.jpg',
      '7',
    ]) {
      expect(
        find.descendant(of: dialog, matching: find.text(value)),
        findsOneWidget,
      );
    }
    expect(
      find.text('Server mengonfirmasi proyek telah disimpan.'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(field('custom_type'), findsNothing);
    expect(inputText(tester, 'display_order'), '0');
    for (final name in [
      'title',
      'role',
      'description',
      'technologies',
      'live_url',
      'source_url',
      'thumbnail_path',
    ]) {
      expect(inputText(tester, name), isEmpty);
    }
    final dropdown = tester.state<FormFieldState<String>>(
      field('project_type'),
    );
    expect(dropdown.value, 'Web Development');

    await fillRequired(tester, title: 'Proyek kedua');
    await preview(tester);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Proyek kedua'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Web Development'),
      ),
      findsOneWidget,
    );
    expect(find.text('Community Study Platform'), findsNothing);
    expect(find.text('Tidak diisi'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Custom project type is required and follows the model length limit',
    (tester) async {
      await openForm(tester);
      await fillRequired(tester);
      await selectType(tester, 'Lainnya');
      await preview(tester);
      expect(
        find.text('Jenis proyek lainnya tidak boleh kosong.'),
        findsOneWidget,
      );
      await enter(tester, 'custom_type', 'a' * 101);
      await preview(tester);
      expect(
        find.text('Jenis proyek lainnya maksimal 100 karakter.'),
        findsOneWidget,
      );
      await selectType(tester, 'Data Science');
      await preview(tester);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Data Science'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('Rejects overlong model fields and invalid URLs', (tester) async {
    await openForm(tester);
    await fillRequired(tester, title: 'a' * 201);
    await enter(tester, 'role', 'b' * 101);
    await enter(tester, 'thumbnail_path', 'c' * 256);
    await enter(tester, 'live_url', 'javascript:alert(1)');
    await enter(tester, 'source_url', 'https://bad host.example');
    await preview(tester);
    expect(find.text('Nama proyek maksimal 200 karakter.'), findsOneWidget);
    expect(find.text('Peran saya maksimal 100 karakter.'), findsOneWidget);
    expect(
      find.text('Path thumbnail (opsional) maksimal 255 karakter.'),
      findsOneWidget,
    );
    expect(
      find.text('Masukkan URL lengkap dengan http:// atau https://.'),
      findsNWidgets(2),
    );
    expect(find.byType(AlertDialog), findsNothing);
  });

  for (final value in ['-1', '1.5', 'abc', '32768']) {
    testWidgets('Rejects display order $value', (tester) async {
      await openForm(tester);
      await fillRequired(tester);
      await enter(tester, 'display_order', value);
      await preview(tester);
      expect(
        find.text('Urutan tampilan harus bilangan bulat 0–32767.'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
    });
  }

  testWidgets('Dismissing the preview keeps the draft', (tester) async {
    await openForm(tester);
    await fillRequired(tester);
    await preview(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(inputText(tester, 'title'), 'Study Hub');
    await preview(tester);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Study Hub'),
      ),
      findsOneWidget,
    );
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'Form and long preview remain usable at 320px, text scale $scale',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 568);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await openForm(tester);
        await fillRequired(tester);
        await selectType(tester, 'Lainnya');
        await enter(tester, 'custom_type', 'Community Study Platform');
        await enter(
          tester,
          'description',
          'Deskripsi panjang untuk menguji scroll.\n' * 20,
        );
        await preview(tester);
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
}
