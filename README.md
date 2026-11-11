# My Portfolio Mobile

Aplikasi portofolio berbasis Flutter untuk pengembangan antarmuka mobile pada
mata kuliah Pemrograman Berbasis Platform. Proyek ini dikembangkan terpisah dari
[backend Django](https://github.com/osman-fardin/myportofolio).

## Identity

- **Name:** Muhammad Osman Fardin
- **NPM:** 2506541723
- **Class:** PBP D

## Technology

- Flutter 3.47.6
- Dart 3.13.5
- Material Design

## Local Setup

Pastikan Flutter SDK dan Google Chrome tersedia. Periksa lingkungan pengembangan:

```bash
flutter doctor
```

Dari direktori proyek, pasang dependency dan jalankan aplikasi:

```bash
flutter pub get
flutter run -d chrome
```

## Project Structure

- `lib/main.dart`: titik masuk, konfigurasi tema, dan halaman awal aplikasi.
- `lib/menu.dart`: halaman utama berbasis StatelessWidget.
- `test/`: pengujian widget.
- `pubspec.yaml`: konfigurasi proyek dan dependency.
- `pubspec.lock`: versi dependency yang digunakan.
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`: konfigurasi platform.

## Testing

```bash
flutter analyze
flutter test
dart format --output=none --set-exit-if-changed lib test
```

Verifikasi awal: analisis statis dan format bersih, satu widget test lulus,
serta counter berhasil bertambah dari 0 menjadi 1 di Chrome.

Setelah pemisahan halaman, analisis statis dan format tetap bersih. Satu widget
test halaman utama lulus, menggantikan test counter yang sudah dihapus.

## Development Progress

Proyek telah diinisialisasi pada commit `3d432c5`. Halaman utama dipisahkan ke
menu.dart sebagai StatelessWidget, dengan tema Material 3 berbasis indigo/amber.
Pengembangan berikutnya mencakup kartu identitas dan menu aksi sesuai materi
Tutorial 08. Integrasi API belum diterapkan. Chrome telah diuji pada tahap awal;
build Android, iOS, dan desktop belum diverifikasi.

## AI Disclosure

Saya menggunakan Codex untuk membantu penjelasan konsep, penyiapan proyek,
penyuntingan kode dan dokumentasi, serta pengujian aplikasi.
Rincian bantuan dicatat pada [AI prompt log](docs/ai-prompt-log.md).
