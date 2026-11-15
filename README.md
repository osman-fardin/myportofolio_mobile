# My Portfolio Mobile

Aplikasi portofolio berbasis Flutter untuk pengembangan antarmuka mobile pada
mata kuliah Pemrograman Berbasis Platform. Proyek ini dikembangkan terpisah dari
[backend Django](https://github.com/osman-fardin/myportofolio).

## Identity

- **Name:** Muhammad Osman Fardin
- **NPM:** 2506541723
- **Class:** PBP D

## Features

- Kartu informasi pemilik portofolio dan pesan sambutan.
- Tiga kartu aksi: Lihat Proyek, Tambah Proyek, dan Logout dengan feedback SnackBar.
- Warna aksi berbeda mengikuti palet web: navy, cloud, dan copper.
- Tampilan mengikuti web: latar paper, Space Grotesk, header bergaris, dan panel About.
- Foto, tekstur latar, serta font tersedia sebagai aset lokal.
- Layout yang dapat digulir, dukungan teks diperbesar, dan aktivasi menu melalui keyboard.

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

- `lib/main.dart`: titik masuk, pemilihan tema, dan pendaftaran lisensi font.
- `lib/menu.dart`: halaman utama, InfoCard, model ItemHomepage, dan ItemCard.
- `lib/theme/portfolio_theme.dart`: warna dan konfigurasi tema bersama.
- `lib/widgets/portfolio_sections.dart`: bagian intro, About, dan footer.
- `assets/`: font beserta lisensi dan gambar dari web portofolio.
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

Verifikasi terakhir: 15 widget test lulus, analisis statis dan format bersih.
Test mencakup isi kartu, layout dan teks 200%, pesan ketiga aksi, tap berulang,
keyboard, warna unik, serta kontras teks/ikon pada warna terang dan gelap.
Test juga memeriksa perubahan susunan kartu dan keterjangkauan About/footer.
Interaksi dan tampilan Chrome diperiksa pada lebar 320, 390, 768, dan 1280 px.
Build web berhasil menggunakan `flutter build web --no-web-resources-cdn`;
font, gambar, dan renderer pada build yang diperiksa termuat dari server lokal.

## Development Progress

Proyek telah diinisialisasi pada commit `3d432c5`. Halaman utama dipisahkan ke
menu.dart sebagai StatelessWidget, dengan tema Material 3.
Halaman menampilkan tiga InfoCard (NPM, Name, Class) dengan identitas Muhammad
Osman Fardin, NPM 2506541723, kelas PBP D. Intro dan About memakai isi profil
serta gaya web yang sama. Grid aksi menjadi satu kolom pada layar sempit atau
teks besar, dan tiga kolom pada layar lebar. Setiap aksi menampilkan pesan
melalui SnackBar. Pada tahap ini tombol belum
melakukan navigasi, penambahan data, atau logout autentikasi. Integrasi API belum
diterapkan; build Android, iOS, dan desktop belum diverifikasi.

### Weekly Progress

| Tahap | Progres |
| --- | --- |
| Tutorial 08, 11 November 2026 | Halaman utama, identitas, tiga kartu aksi, SnackBar, dan widget test; PR #1 merged. |
| Tugas 7, 14 November 2026 | Warna per ItemHomepage, kontras teks/ikon, dan adaptasi tampilan web. Enam refleksi menyusul. |

Warna disimpan pada model ItemHomepage dan diterapkan langsung oleh ItemCard.
Palet navy `#23354D`, cloud `#526F7A`, dan copper `#B6643D` berasal dari
[stylesheet web portofolio](https://github.com/osman-fardin/myportofolio/blob/main/static/css/style.css).
Teks/ikon hitam atau putih dipilih berdasarkan rasio kontras terhadap warna
kartu. Test memeriksa rasio label minimal 4.5:1; ini tidak menyatakan seluruh
aplikasi sudah memenuhi semua kriteria aksesibilitas.

Font Space Grotesk disertakan bersama SIL Open Font License 1.1. Gambar dan
teks profil mengikuti repo web yang sama; sumber aset dicatat pada
[Visual Assets](assets/README.md). Tidak ada paket runtime tambahan.

## AI Disclosure

Saya menggunakan Codex untuk membantu penjelasan konsep, penyiapan proyek,
penyuntingan kode dan dokumentasi, serta pengujian aplikasi.
Rincian bantuan dicatat pada [AI prompt log](docs/ai-prompt-log.md).
