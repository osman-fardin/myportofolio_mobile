import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/portfolio_theme.dart';

String formatLocalDateTime(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${local.year.toString().padLeft(4, '0')}-'
      '${two(local.month)}-${two(local.day)} '
      '${two(local.hour)}:${two(local.minute)}';
}

/// Menggabungkan dua picker sebagai satu nilai `FormField<DateTime>`.
/// Draft baru diterapkan setelah tanggal dan jam sama-sama dikonfirmasi.
class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    required this.label,
    required String emptyText,
    super.initialValue,
    bool allowClear = false,
    ValueChanged<DateTime?>? onChanged,
    super.validator,
    super.key,
  }) : super(
         autovalidateMode: AutovalidateMode.onUserInteraction,
         builder: (field) => InputDecorator(
           decoration: InputDecoration(
             labelText: label,
             floatingLabelBehavior: FloatingLabelBehavior.always,
             filled: true,
             fillColor: PortfolioColors.surface,
             errorText: field.errorText,
             errorMaxLines: 3,
             border: const OutlineInputBorder(
               borderRadius: PortfolioTheme.radius,
             ),
             enabledBorder: const OutlineInputBorder(
               borderRadius: PortfolioTheme.radius,
               borderSide: BorderSide(color: PortfolioColors.line),
             ),
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 field.value == null
                     ? emptyText
                     : formatLocalDateTime(field.value!),
               ),
               const SizedBox(height: 12),
               Wrap(
                 spacing: 12,
                 runSpacing: 8,
                 children: [
                   OutlinedButton.icon(
                     onPressed: () => _pick(field, label, onChanged),
                     icon: const Icon(Icons.calendar_month_outlined),
                     label: const Text('Pilih tanggal/jam'),
                   ),
                   if (allowClear && field.value != null)
                     TextButton(
                       onPressed: () {
                         field.didChange(null);
                         onChanged?.call(null);
                       },
                       child: const Text('Hapus waktu selesai'),
                     ),
                 ],
               ),
             ],
           ),
         ),
       );

  final String label;

  static Future<void> _pick(
    FormFieldState<DateTime> field,
    String label,
    ValueChanged<DateTime?>? onChanged,
  ) async {
    FocusScope.of(field.context).unfocus();
    final previous = (field.value ?? DateTime.now()).toLocal();
    final date = await showDatePicker(
      context: field.context,
      initialDate: previous,
      firstDate: DateTime(1),
      lastDate: DateTime(9999, 12, 31),
      helpText: label,
      cancelText: 'Batal',
      confirmText: 'Lanjut',
    );
    if (!field.mounted || date == null) return;

    final time = await showTimePicker(
      context: field.context,
      initialTime: TimeOfDay.fromDateTime(previous),
      helpText: label,
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (!field.mounted || time == null) return;

    final value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    field.didChange(value);
    onChanged?.call(value);
  }
}
