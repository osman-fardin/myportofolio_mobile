import 'dart:async';
import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

import 'support/test_app.dart';
import 'api_client_test.dart' show sample;
import 'project_form_test.dart' show fillRequired, preview;

void main() {
  for (final status in [401, 403]) {
    testWidgets(
      'Project HTTP $status does not show success or expose raw errors',
      (tester) async {
        final api = ApiClient(
          client: MockClient(
            (r) async => http.Response('private debug output', status),
          ),
        );
        await tester.pumpWidget(testHarness(const ProjectFormPage(), api: api));
        await fillRequired(tester);
        await preview(tester);
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.textContaining('private debug output'), findsNothing);
        if (status == 401) {
          expect(find.byType(LoginScreen), findsOneWidget);
          await tester.tap(find.byType(BackButton));
          await tester.pumpAndSettle();
          expect(
            find.text('Login untuk membuka formulir proyek.'),
            findsOneWidget,
          );
        } else {
          expect(find.textContaining('HTTP 403'), findsOneWidget);
          expect(
            find.widgetWithText(TextFormField, 'Study Hub'),
            findsOneWidget,
          );
        }
      },
    );
  }
  testWidgets(
    'Pending project submit is sent once and only 201 shows confirmation',
    (tester) async {
      var posts = 0;
      final response = Completer<http.Response>();
      final api = ApiClient(
        client: MockClient((r) {
          posts++;
          return response.future;
        }),
      );
      await tester.pumpWidget(testHarness(const ProjectFormPage(), api: api));
      await fillRequired(tester);
      final button = find.widgetWithText(ElevatedButton, 'Simpan proyek');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
      expect(posts, 1);
      expect(find.text('Menyimpan…'), findsOneWidget);
      expect(
        tester
            .widget<ElevatedButton>(
              find.widgetWithText(ElevatedButton, 'Menyimpan…'),
            )
            .onPressed,
        isNull,
      );
      response.complete(
        http.Response(jsonEncode({...sample.toJson(), 'id': 'new-id'}), 201),
      );
      await tester.pumpAndSettle();
      expect(find.text('Proyek berhasil disimpan'), findsOneWidget);
      expect(posts, 1);
    },
  );
  testWidgets('Guest add-project opens login and Back cancels the guard', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(loggedIn: false));
    final card = find.widgetWithText(ItemCard, 'Tambah Proyek');
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsNothing);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byType(ProjectFormPage), findsNothing);
  });
  testWidgets(
    'Login validates credentials and continues the guarded destination',
    (tester) async {
      await tester.pumpWidget(testApp(loggedIn: false));
      final card = find.widgetWithText(ItemCard, 'Tambah Proyek');
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      expect(find.text('Username tidak boleh kosong.'), findsOneWidget);
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'owner');
      await tester.enterText(fields.at(1), 'password');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectFormPage), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    },
  );
  testWidgets('Login failure stays on screen and does not show server HTML', (
    tester,
  ) async {
    final api = ApiClient(
      client: MockClient((r) async => http.Response('private HTML', 400)),
    );
    await tester.pumpWidget(MyApp(apiClient: api));
    final card = find.widgetWithText(ItemCard, 'Tambah Proyek');
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'owner');
    await tester.enterText(fields.at(1), 'wrong');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.textContaining('HTTP 400'), findsOneWidget);
    expect(find.textContaining('private HTML'), findsNothing);
  });
  testWidgets('List fetches once per state; retry/refresh and detail work', (
    tester,
  ) async {
    var calls = 0;
    final api = ApiClient(
      client: MockClient((r) async {
        calls++;
        return http.Response(jsonEncode([sample.toJson()]), 200);
      }),
    );
    await tester.pumpWidget(
      testHarness(const ProjectListScreen(), api: api, loggedIn: false),
    );
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.text(sample.title), findsOneWidget);
    await tester.pump();
    expect(calls, 1);
    await tester.tap(find.byTooltip('Refresh proyek'));
    await tester.pumpAndSettle();
    expect(calls, 2);
    await tester.tap(find.widgetWithText(ListTile, sample.title));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text(sample.technologies), findsOneWidget);
  });
  testWidgets('Empty state refreshes and errors can be retried', (
    tester,
  ) async {
    var calls = 0;
    final api = ApiClient(
      client: MockClient((r) async {
        calls++;
        return calls == 1
            ? http.Response('error', 500)
            : http.Response('[]', 200);
      }),
    );
    await tester.pumpWidget(testHarness(const ProjectListScreen(), api: api));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada proyek.'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(calls, greaterThanOrEqualTo(3));
  });
  testWidgets('Pending public fetch shows loading then a usable empty list', (
    tester,
  ) async {
    final response = Completer<http.Response>();
    final api = ApiClient(client: MockClient((r) => response.future));
    await tester.pumpWidget(testHarness(const ProjectListScreen(), api: api));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    response.complete(http.Response('[]', 200));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada proyek.'), findsOneWidget);
  });
  testWidgets('Direct form entry is guarded even without a card', (
    tester,
  ) async {
    await tester.pumpWidget(
      testHarness(const ProjectFormPage(), loggedIn: false),
    );
    await tester.pumpAndSettle();
    expect(find.text('Login untuk membuka formulir proyek.'), findsOneWidget);
    expect(find.byType(Form), findsNothing);
  });
}
