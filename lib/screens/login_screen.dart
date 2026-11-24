import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _busy = false;
  Future<void> _submit() async {
    if (_busy || !_key.currentState!.validate()) return;
    _key.currentState!.save();
    setState(() => _busy = true);
    try {
      await context.read<AuthState>().login(_username, _password);
      if (!mounted) return;
      if (context.read<AuthState>().isLoggedIn) Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('${error.message} (HTTP ${error.statusCode})'),
          ),
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Masuk untuk menambahkan proyek. Hak akses tetap diperiksa oleh server.',
                ),
                const SizedBox(height: 24),
                TextFormField(
                  enabled: !_busy,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  autofillHints: const [AutofillHints.username],
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Username tidak boleh kosong.'
                      : null,
                  onSaved: (value) => _username = value!.trim(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  enabled: !_busy,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofillHints: const [AutofillHints.password],
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Password tidak boleh kosong.'
                      : null,
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _busy ? null : _submit,
                  child: Text(_busy ? 'Memproses…' : 'Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
