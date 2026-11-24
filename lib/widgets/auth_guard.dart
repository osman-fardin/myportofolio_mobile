import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

Future<void> logoutWithFeedback(BuildContext context) async {
  try {
    await context.read<AuthState>().logout();
  } on ApiException {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Sesi lokal ditutup. Server belum mengonfirmasi pencabutan token.',
          ),
        ),
      );
  }
}

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
  return context.mounted &&
      result == true &&
      context.read<AuthState>().isLoggedIn;
}

class LoginRequired extends StatelessWidget {
  const LoginRequired({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Login untuk membuka formulir proyek.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ensureLoggedIn(context),
            child: const Text('Login'),
          ),
        ],
      ),
    ),
  );
}
