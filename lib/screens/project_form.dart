import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

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
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();
    FocusScope.of(context).unfocus();

    // Ambil snapshot input; dialog tidak bergantung pada state yang di-reset.
    final summary = {
      'Nama proyek': _values['title']!,
      'Jenis proyek': _selectedType == _otherType
          ? _values['custom_type']!
          : _selectedType,
      'Peran saya': _values['role']!,
      'Deskripsi': _values['description']!,
      'Teknologi': _values['technologies']!,
      'URL proyek': _values['live_url']!,
      'URL source code': _values['source_url']!,
      'Path thumbnail': _values['thumbnail_path']!,
      'Urutan tampilan': int.parse(_values['display_order']!).toString(),
    };
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ringkasan proyek'),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ini pratinjau lokal. Data belum disimpan ke portofolio.',
                ),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
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
                      _input('custom_type', 'Jenis proyek lainnya', limit: 100),
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
                      onPressed: _preview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PortfolioColors.navy,
                        foregroundColor: PortfolioColors.surface,
                        padding: const EdgeInsets.all(18),
                        shape: const RoundedRectangleBorder(
                          borderRadius: PortfolioTheme.radius,
                        ),
                      ),
                      child: const Text('Pratinjau proyek'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
