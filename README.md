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
- `lib/menu.dart`: halaman utama dan komponen kartu informasi InfoCard.
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

Setelah penambahan kartu informasi, enam widget test lulus: isi profil,
penggunaan ulang InfoCard, serta layout pada layar kecil, desktop, dan teks 200%.
Analisis statis dan format bersih. Tampilan Chrome diperiksa pada lebar 320,
390, dan 1280 px; teks 200% diuji melalui widget test.

## Development Progress

Proyek telah diinisialisasi pada commit `3d432c5`. Halaman utama dipisahkan ke
menu.dart sebagai StatelessWidget, dengan tema Material 3 berbasis indigo/amber.
Halaman menampilkan tiga InfoCard (NPM, Name, Class) dan sambutan dengan
identitas Muhammad Osman Fardin, NPM 2506541723, kelas PBP D. Struktur halaman
mengikuti pola tutorial dengan data pemilik portofolio. Pengembangan berikutnya
mencakup menu aksi. Integrasi API belum diterapkan; build Android, iOS, dan
desktop belum diverifikasi.

## AI Disclosure

Saya menggunakan Codex untuk membantu penjelasan konsep, penyiapan proyek,
penyuntingan kode dan dokumentasi, serta pengujian aplikasi.
Rincian bantuan dicatat pada [AI prompt log](docs/ai-prompt-log.md).
