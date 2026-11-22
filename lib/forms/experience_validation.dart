/// Aturan input lokal berdasarkan Experience pada backend portofolio.
/// Validasi backend tetap diperlukan ketika aplikasi nanti terhubung ke API.
abstract final class ExperienceValidation {
  static const defaultCategory = 'full-time';
  static const categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  static String? title(String? raw) {
    final value = (raw ?? '').trim();
    if (value.isEmpty) return 'Judul pengalaman tidak boleh kosong.';
    // Django menghitung karakter Unicode, bukan jumlah unit UTF-16 Dart.
    if (value.runes.length > 255) {
      return 'Judul pengalaman maksimal 255 karakter.';
    }
    return null;
  }

  static String? description(String? raw) {
    if ((raw ?? '').trim().isEmpty) {
      return 'Deskripsi pengalaman tidak boleh kosong.';
    }
    return null;
  }

  static String? category(String? value) {
    if (!categories.containsKey(value)) {
      return 'Pilih kategori pengalaman yang tersedia.';
    }
    return null;
  }

  static String? thumbnail(String? raw) {
    final value = (raw ?? '').trim();
    if (value.isEmpty) return null;
    if (value.runes.length > 200) {
      return 'URL thumbnail maksimal 200 karakter.';
    }
    final uri = Uri.tryParse(value);
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        RegExp(r'\s').hasMatch(value)) {
      return 'Masukkan URL thumbnail lengkap dengan http:// atau https://.';
    }
    return null;
  }

  static String? startedAt(DateTime? value) {
    if (value == null) return 'Pilih tanggal dan waktu mulai.';
    return null;
  }

  /// Akhir kosong berarti masih berlangsung. Waktu yang sama tetap valid,
  /// sesuai aturan backend yang hanya menolak akhir lebih awal dari mulai.
  static String? endedAt(DateTime? value, {required DateTime? startedAt}) {
    if (value != null && startedAt != null && value.isBefore(startedAt)) {
      return 'Waktu selesai tidak boleh lebih awal dari waktu mulai.';
    }
    return null;
  }
}
