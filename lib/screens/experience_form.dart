import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/forms/experience_validation.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';
import 'package:myportofolio_mobile/widgets/date_time_form_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _startKey = GlobalKey<FormFieldState<DateTime>>();
  final _endKey = GlobalKey<FormFieldState<DateTime>>();
  final _values = <String, String>{};
  late final DateTime _initialStart;
  String _category = ExperienceValidation.defaultCategory;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _initialStart = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
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

  Widget _textInput(
    String field,
    String label,
    FormFieldValidator<String> validator, {
    int lines = 1,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        key: ValueKey('experience-$field'),
        minLines: lines,
        maxLines: lines == 1 ? 1 : null,
        keyboardType: keyboardType,
        textInputAction: lines == 1
            ? TextInputAction.next
            : TextInputAction.newline,
        decoration: _decoration(label, hint: hint),
        validator: validator,
        onSaved: (value) => _values[field] = (value ?? '').trim(),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    final end = _endKey.currentState!.value;
    final summary = {
      'Judul pengalaman': _values['title']!,
      'Deskripsi': _values['description']!,
      'Kategori': ExperienceValidation.categories[_category]!,
      'URL thumbnail': _values['thumbnail']!.isEmpty
          ? 'Tidak diisi'
          : _values['thumbnail']!,
      'Waktu mulai': formatLocalDateTime(_startKey.currentState!.value!),
      'Waktu selesai': end == null
          ? 'Masih berlangsung'
          : formatLocalDateTime(end),
    };
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ringkasan pengalaman'),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ini pratinjau lokal. Data belum disimpan ke portofolio. '
                  'Tanggal dan jam mengikuti zona waktu perangkat.',
                ),
                const SizedBox(height: 24),
                for (final entry in summary.entries) ...[
                  Text(
                    entry.key,
                    style: Theme.of(dialogContext).textTheme.titleSmall,
                  ),
                  Text(entry.value),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset() async {
    FocusScope.of(context).unfocus();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset formulir?'),
        content: const Text(
          'Semua isian draft akan dikembalikan ke nilai awal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    // Form.reset juga mereset field tanggal dan error, bukan hanya teks.
    _formKey.currentState!.reset();
    _values.clear();
    _category = ExperienceValidation.defaultCategory;
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = ModalRoute.of(context)?.canPop ?? false;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pengalaman',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: canGoBack ? const BackButton() : const DrawerButton(),
        actions: [if (canGoBack) const DrawerButton()],
      ),
      drawer: const LeftDrawer(destination: PortfolioDestination.addExperience),
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
                      'Detail pengalaman',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Isi pengalaman dan tanggung jawabmu. Tanggal dan jam '
                      'mengikuti zona waktu perangkat. Waktu selesai boleh '
                      'kosong jika masih berlangsung.',
                    ),
                    const SizedBox(height: 28),
                    _textInput(
                      'title',
                      'Judul pengalaman',
                      ExperienceValidation.title,
                    ),
                    _textInput(
                      'description',
                      'Deskripsi',
                      ExperienceValidation.description,
                      lines: 4,
                      hint:
                          'Tulis satu tanggung jawab atau pencapaian per baris',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: DropdownButtonFormField<String>(
                        key: const ValueKey('experience-category'),
                        initialValue: ExperienceValidation.defaultCategory,
                        isExpanded: true,
                        itemHeight: null,
                        decoration: _decoration('Kategori'),
                        items: ExperienceValidation.categories.entries
                            .map(
                              (entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                        validator: ExperienceValidation.category,
                        onChanged: (value) {
                          if (value != null) _category = value;
                        },
                      ),
                    ),
                    _textInput(
                      'thumbnail',
                      'URL thumbnail (opsional)',
                      ExperienceValidation.thumbnail,
                      hint: 'https://example.com/photo.jpg',
                      keyboardType: TextInputType.url,
                    ),
                    DateTimeFormField(
                      key: _startKey,
                      label: 'Waktu mulai',
                      emptyText: 'Belum dipilih',
                      initialValue: _initialStart,
                      validator: ExperienceValidation.startedAt,
                      // Mulai yang baru dapat membuat waktu akhir lama tidak valid.
                      onChanged: (_) => _endKey.currentState?.validate(),
                    ),
                    const SizedBox(height: 20),
                    DateTimeFormField(
                      key: _endKey,
                      label: 'Waktu selesai (opsional)',
                      emptyText: 'Masih berlangsung',
                      allowClear: true,
                      validator: (value) => ExperienceValidation.endedAt(
                        value,
                        startedAt: _startKey.currentState?.value,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PortfolioColors.navy,
                        foregroundColor: PortfolioColors.surface,
                        padding: const EdgeInsets.all(18),
                        shape: const RoundedRectangleBorder(
                          borderRadius: PortfolioTheme.radius,
                        ),
                      ),
                      child: const Text('Simpan'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _confirmReset,
                      child: const Text('Reset formulir'),
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
