import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  static const _defaultType = 'Web Development';
  static const _otherType = 'Lainnya';
  static const _projectTypes = [
    _defaultType,
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    _otherType,
  ];

  final _formKey = GlobalKey<FormState>();
  final _values = <String, String>{};
  String _selectedType = _defaultType;
  bool _submitting = false;

  String? _validateUrl(String value) {
    if (value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        RegExp(r'\s').hasMatch(value)) {
      return 'Masukkan URL lengkap dengan http:// atau https://.';
    }
    return null;
  }

  String? _validateOrder(String value) {
    final order = int.tryParse(value);
    if (!RegExp(r'^\d+$').hasMatch(value) || order == null || order > 32767) {
      return 'Urutan tampilan harus bilangan bulat 0–32767.';
    }
    return null;
  }

  Widget _input(
    String field,
    String label, {
    bool required = true,
    int? limit,
    int lines = 1,
    String? hint,
    String? initialValue,
    TextInputType? keyboardType,
    String? Function(String)? validate,
  }) {
    return Padding(
      key: ValueKey('field-group-$field'),
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        key: ValueKey(field),
        initialValue: initialValue,
        minLines: lines,
        maxLines: lines == 1 ? 1 : null,
        keyboardType: keyboardType,
        textInputAction: lines == 1
            ? TextInputAction.next
            : TextInputAction.newline,
        decoration: _decoration(label, hint: hint),
        validator: (raw) {
          final value = (raw ?? '').trim();
          if (required && value.isEmpty) return '$label tidak boleh kosong.';
          if (limit != null && value.runes.length > limit) {
            return '$label maksimal $limit karakter.';
          }
          return validate?.call(value);
        },
        onSaved: (value) => _values[field] = (value ?? '').trim(),
      ),
    );
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: PortfolioColors.surface,
      errorMaxLines: 3,
      border: const OutlineInputBorder(borderRadius: PortfolioTheme.radius),
      enabledBorder: const OutlineInputBorder(
        borderRadius: PortfolioTheme.radius,
        borderSide: BorderSide(color: PortfolioColors.line),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }

  Future<void> _preview() async {
    if (_submitting) return;
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();
    FocusScope.of(context).unfocus();

    if (!await ensureLoggedIn(context) || !mounted) return;
    final auth = context.read<AuthState>();
    late final Project created;
    setState(() => _submitting = true);
    try {
      created = await context.read<ApiClient>().createProject(
        Project(
          title: _values['title']!,
          projectType: _selectedType == _otherType
              ? _values['custom_type']!
              : _selectedType,
          role: _values['role']!,
          description: _values['description']!,
          technologies: _values['technologies']!,
          liveUrl: _values['live_url']!,
          sourceUrl: _values['source_url']!,
          thumbnailPath: _values['thumbnail_path']!,
          displayOrder: int.parse(_values['display_order']!),
        ),
        token: auth.token!,
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('${error.message} (HTTP ${error.statusCode})'),
          ),
        );
      if (error.statusCode == 401) {
        auth.invalidate();
        await ensureLoggedIn(context);
      }
      return;
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
    if (!mounted || !auth.isLoggedIn) return;

    // Ambil snapshot input; dialog tidak bergantung pada state yang di-reset.
    final summary = {
      'Nama proyek': created.title,
      'Jenis proyek': created.projectType,
      'Peran saya': created.role,
      'Deskripsi': created.description,
      'Teknologi': created.technologies,
      'URL proyek': created.liveUrl,
      'URL source code': created.sourceUrl,
      'Path thumbnail': created.thumbnailPath,
      'Urutan tampilan': created.displayOrder.toString(),
    };
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil disimpan'),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Server mengonfirmasi proyek telah disimpan.'),
                const SizedBox(height: 24),
                for (final entry in summary.entries) ...[
                  Text(
                    entry.key,
                    style: Theme.of(dialogContext).textTheme.titleSmall,
                  ),
                  Text(entry.value.isEmpty ? 'Tidak diisi' : entry.value),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    // Reset field dan pilihan bersama agar submit berikutnya tidak memakai data lama.
    form.reset();
    setState(() {
      _values.clear();
      _selectedType = _defaultType;
    });
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Proyek'),
        leading: canGoBack ? const BackButton() : const DrawerButton(),
        actions: [if (canGoBack) const DrawerButton()],
      ),
      drawer: const LeftDrawer(destination: PortfolioDestination.addProject),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Offstage(
            offstage: !context.watch<AuthState>().isLoggedIn,
            child: AbsorbPointer(
              absorbing: _submitting,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 28,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Detail proyek',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Isi informasi proyek untuk melihat ringkasannya. '
                              'Field bertanda opsional boleh dikosongkan.',
                            ),
                            const SizedBox(height: 28),
                            _input('title', 'Nama proyek', limit: 200),
                            Padding(
                              key: const ValueKey('project-type-group'),
                              padding: const EdgeInsets.only(bottom: 20),
                              child: DropdownButtonFormField<String>(
                                key: const ValueKey('project_type'),
                                initialValue: _defaultType,
                                isExpanded: true,
                                itemHeight: null,
                                decoration: _decoration('Jenis proyek'),
                                items: _projectTypes
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _selectedType = value);
                                  }
                                },
                              ),
                            ),
                            if (_selectedType == _otherType)
                              _input(
                                'custom_type',
                                'Jenis proyek lainnya',
                                limit: 100,
                              ),
                            _input('role', 'Peran saya', limit: 100),
                            _input('description', 'Deskripsi', lines: 4),
                            _input(
                              'technologies',
                              'Teknologi',
                              lines: 3,
                              hint: 'Tulis satu teknologi per baris',
                            ),
                            _input(
                              'live_url',
                              'URL proyek',
                              limit: 200,
                              hint: 'https://example.com',
                              keyboardType: TextInputType.url,
                              validate: _validateUrl,
                            ),
                            _input(
                              'source_url',
                              'URL source code (opsional)',
                              required: false,
                              limit: 200,
                              keyboardType: TextInputType.url,
                              validate: _validateUrl,
                            ),
                            _input(
                              'thumbnail_path',
                              'Path thumbnail (opsional)',
                              required: false,
                              limit: 255,
                              hint: 'img/project-preview.jpg',
                            ),
                            _input(
                              'display_order',
                              'Urutan tampilan',
                              initialValue: '0',
                              keyboardType: TextInputType.number,
                              validate: _validateOrder,
                            ),
                            const SizedBox(height: 4),
                            ElevatedButton(
                              onPressed: _submitting ? null : _preview,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: PortfolioColors.navy,
                                foregroundColor: PortfolioColors.surface,
                                padding: const EdgeInsets.all(18),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: PortfolioTheme.radius,
                                ),
                              ),
                              child: Text(
                                _submitting ? 'Menyimpan…' : 'Simpan proyek',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!context.watch<AuthState>().isLoggedIn) const LoginRequired(),
        ],
      ),
    );
  }
}
