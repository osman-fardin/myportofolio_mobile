import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Space Grotesk'], license);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({this.apiClient, this.initialToken, super.key});
  final ApiClient? apiClient;
  final String? initialToken;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => apiClient ?? ApiClient(),
          dispose: (_, api) => api.close(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AuthState(context.read<ApiClient>(), initialToken: initialToken),
        ),
      ],
      child: MaterialApp(
        title: 'MyPortfolio',
        theme: PortfolioTheme.light,
        home: const MyHomePage(),
      ),
    );
  }
}
