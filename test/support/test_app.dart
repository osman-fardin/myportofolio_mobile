import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';

ApiClient fixtureApi() => ApiClient(
  client: MockClient((request) async {
    if (request.url.path.endsWith('/auth/token/')) {
      return http.Response('{"token":"fixture-token"}', 200);
    }
    if (request.url.path.endsWith('/auth/logout/')) {
      return http.Response('', 204);
    }
    if (request.method == 'POST') {
      return http.Response(
        jsonEncode({
          ...jsonDecode(request.body) as Map<String, dynamic>,
          'id': 'fixture-id',
        }),
        201,
      );
    }
    return http.Response('[]', 200);
  }),
);

Widget testApp({bool loggedIn = true}) => MyApp(
  apiClient: fixtureApi(),
  initialToken: loggedIn ? 'fixture-token' : null,
);
Widget testHarness(Widget home, {ApiClient? api, bool loggedIn = true}) {
  final client = api ?? fixtureApi();
  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: client),
      ChangeNotifierProvider(
        create: (_) =>
            AuthState(client, initialToken: loggedIn ? 'fixture-token' : null),
      ),
    ],
    child: MaterialApp(theme: PortfolioTheme.light, home: home),
  );
}
