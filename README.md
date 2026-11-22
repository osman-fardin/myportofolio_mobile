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
- Empat kartu aksi: Lihat Proyek, Tambah Proyek, Tambah Pengalaman, dan Logout.
- Feedback SnackBar dan warna aksi berbeda: navy, cloud, walnut, dan copper.
- Tampilan mengikuti web: latar paper, Space Grotesk, header bergaris, dan panel About.
- Foto, tekstur latar, serta font tersedia sebagai aset lokal.
- Layout yang dapat digulir, dukungan teks diperbesar, dan aktivasi menu melalui keyboard.
- Drawer bersama dengan Home, Tambah Proyek, dan Tambah Pengalaman.
- Form proyek dengan validasi, dialog ringkasan, dan reset setelah konfirmasi.
- Form Experience dengan enam field, pemilih tanggal/jam, dan ringkasan lokal,
  dapat dibuka melalui kartu serta drawer.
- Reset draft Experience dengan konfirmasi; pembatalan mempertahankan isian.

## Technology

- Flutter 3.47.6
- Dart 3.13.5
- Material Design
- Material UI (`material_ui`), pustaka komponen Material yang terpisah dari SDK.

## Local Setup

Clone repositori dan masuk ke direktori proyek:

```bash
git clone https://github.com/osman-fardin/myportofolio_mobile.git
cd myportofolio_mobile
```

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
- `lib/screens/menu.dart`: halaman utama dan InfoCard.
- `lib/screens/project_form.dart`: formulir proyek dan pratinjau input lokal.
- `lib/screens/experience_form.dart`: formulir pengalaman dan dialog ringkasan.
- `lib/forms/experience_validation.dart`: aturan validasi input Experience.
- `lib/widgets/date_time_form_field.dart`: field tanggal/jam yang mengikuti siklus Form.
- `lib/widgets/project_card.dart`: model ItemHomepage dan widget ItemCard.
- `lib/widgets/left_drawer.dart`: drawer bersama dan pemilihan halaman tujuan.
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

Verifikasi terakhir: 64 test lulus (49 widget test dan 15 unit test validasi
Experience), analisis statis dan format bersih.
Test mencakup isi kartu, layout dan teks 200%, pesan keempat aksi, tap berulang,
keyboard, warna unik, serta kontras teks/ikon pada warna terang dan gelap.
Test juga memeriksa perubahan susunan kartu dan keterjangkauan About/footer.
Sebelas test form Project mencakup input wajib, batas panjang, URL, urutan tampilan,
jenis bebas, ringkasan, reset, pembatalan dialog, dan layar 320 px/teks 200%.
Delapan test navigasi memeriksa Back dari kartu, pergantian halaman melalui drawer,
pilihan halaman aktif tanpa kehilangan draft, riwayat campuran, serta drawer
pada layar 320 px/teks 200%. Test keyboard memperhitungkan tombol drawer baru.
Test validasi Experience memeriksa teks wajib, batas judul 255 karakter Unicode,
enam kategori backend, thumbnail opsional/HTTP(S)/maksimal 200 karakter, serta
urutan tanggal dan jam termasuk perbandingan offset zona waktu.
Empat belas widget test Experience memeriksa validasi form, seluruh nilai dialog,
pembatalan picker, revalidasi waktu selesai, penghapusan waktu akhir, draft,
layar 320 px/teks 200%, serta tinggi layar yang berkurang karena keyboard.
Reset diuji pada jalur batal/setuju, termasuk seluruh teks, kategori, waktu,
error validasi, dan submit sesudah reset.
Pada checkpoint Tugas 7, interaksi dan tampilan Chrome diperiksa pada lebar
320, 390, 768, dan 1280 px. Build web saat itu berhasil menggunakan
`flutter build web --no-web-resources-cdn`;
font, gambar, dan renderer pada build yang diperiksa termuat dari server lokal.
Build web Tutorial 09 juga berhasil. Chrome diperiksa untuk drawer/form pada
390 px, dialog pada 320/390 px, serta Home/form dan browser Back pada 1280 px.
Pengisian dengan keyboard, dropdown jenis bebas, ringkasan, dan reset setelah
OK dicoba; console yang diperiksa mencatat nol error/warning. Font, renderer,
dan gambar pada sesi ini termuat lokal. Build native belum diverifikasi.

## Development Progress

Proyek telah diinisialisasi pada commit `3d432c5`. Halaman utama dipisahkan ke
menu.dart sebagai StatelessWidget, dengan tema Material 3.
Halaman menampilkan tiga InfoCard (NPM, Name, Class) dengan identitas Muhammad
Osman Fardin, NPM 2506541723, kelas PBP D. Intro dan About memakai isi profil
serta gaya web yang sama. Grid aksi menjadi satu kolom pada layar sempit atau
teks besar, dua kolom pada lebar menengah, dan empat pada layar lebar. Setiap aksi menampilkan pesan
melalui SnackBar. Kartu Tambah Proyek dan Tambah Pengalaman membuka form masing-masing;
drawer menghubungkan ketiga halaman. Lihat Proyek dan Logout masih berupa feedback SnackBar. Form belum
menyimpan data. Integrasi API belum diterapkan; build Android, iOS, dan desktop
belum diverifikasi.

### Weekly Progress

| Tahap | Progres |
| --- | --- |
| Tutorial 08, 11 November 2026 | Halaman utama, identitas, tiga kartu aksi, SnackBar, dan widget test; PR #1 merged pada checkpoint `e642989`. |
| Tugas 7, 14–15 November 2026 | Warna kartu pada `050626a`, adaptasi UI web pada `9bf2248`, 15 widget test, serta enam refleksi pada README ini. |
| Tutorial 09, 17 November 2026 | Material UI pada `c882558`, pemisahan screen/widget pada `07e3c0c`, form pada `d8ad32c`, serta drawer/navigasi dengan total 31 test. |
| Tugas 8, 22 November 2026 | Validasi pada `c8a3dcf`, form Experience/picker/dialog, kartu keempat, drawer bersama dan reset dengan konfirmasi; total 64 test. |

Warna disimpan pada model ItemHomepage dan diterapkan langsung oleh ItemCard.
Palet navy `#23354D`, cloud `#526F7A`, dan copper `#B6643D` berasal dari
[stylesheet web portofolio](https://github.com/osman-fardin/myportofolio/blob/main/static/css/style.css).
Teks/ikon hitam atau putih dipilih berdasarkan rasio kontras terhadap warna
kartu. Test memeriksa rasio label minimal 4.5:1; ini tidak menyatakan seluruh
aplikasi sudah memenuhi semua kriteria aksesibilitas.

Font Space Grotesk disertakan bersama SIL Open Font License 1.1. Gambar dan
teks profil mengikuti repo web yang sama; sumber aset dicatat pada
[Visual Assets](assets/README.md). Tutorial 09 memakai `material_ui` sesuai
[panduan migrasi resmi Flutter](https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui).
Impor aplikasi dan test memakai pustaka yang sama agar tipe komponen dan tema
konsisten. Flutter SDK tetap 3.47.6.

## Project Form

Form mengikuti field `Project` pada backend portofolio. Data hanya ditampilkan
dalam dialog pratinjau, belum dikirim ke API atau disimpan ke database.

| Field | Aturan input |
| --- | --- |
| `title` | Nama proyek wajib, maksimal 200 karakter. |
| `project_type` | Pilihan jenis proyek; Lainnya membuka teks bebas wajib, maksimal 100 karakter. |
| `role` | Peran wajib, maksimal 100 karakter. |
| `description` | Deskripsi wajib. |
| `technologies` | Teknologi wajib, satu teknologi per baris. |
| `live_url` | URL proyek wajib, HTTP(S), maksimal 200 karakter. |
| `source_url` | URL source code opsional, HTTP(S), maksimal 200 karakter. |
| `thumbnail_path` | Path thumbnail opsional, maksimal 255 karakter. |
| `display_order` | Bilangan bulat 0–32767, nilai awal 0. |

Pilihan dropdown adalah bantuan input untuk `project_type` yang berupa teks
bebas, bukan enum baru pada backend. Validasi lokal ini tidak menggantikan
validasi backend saat API dihubungkan nanti. Isian dirapikan dengan trim;
field wajib menolak input yang hanya berisi spasi. Tombol Pratinjau proyek
menjalankan `FormState.validate()` dan `save()` sebelum membuka dialog.
Menekan OK mereset seluruh input dan pilihan. Menutup dialog dengan Back atau
klik di luar dialog mempertahankan draft. Pola Form/GlobalKey mengacu pada
[panduan validasi Flutter](https://docs.flutter.dev/cookbook/forms/validation).

## Experience Form Progress

Aturan input Experience dipisahkan dari widget. Form mengacu pada model backend:
`title`, `description`, `category`, `thumbnail`, `started_at`, dan `ended_at`.
Kategori mengikuti enam pilihan backend dengan nilai awal `full-time`.
Judul dan deskripsi wajib berisi teks; judul dibatasi 255 karakter. Thumbnail
opsional diperiksa sebagai URL HTTP(S), maksimal 200 karakter. Waktu mulai
wajib, sedangkan waktu selesai boleh kosong untuk pengalaman yang masih
berlangsung. Waktu selesai yang lebih awal ditolak; waktu yang sama diterima.

ExperienceFormPage memakai StatefulWidget, Form, dan GlobalKey<FormState>.
Simpan memvalidasi seluruh field sebelum menampilkan semua isian dalam dialog.
OK atau pembatalan dialog mempertahankan draft untuk dikoreksi. Picker tanggal
diikuti picker jam; membatalkan salah satunya tidak mengubah nilai lama. Nilai
awal mulai mengikuti waktu sekarang, dan waktu selesai dapat dihapus kembali
menjadi Masih berlangsung. Perubahan mulai memvalidasi ulang waktu selesai.
Tanggal/jam ditampilkan dalam zona waktu perangkat, dengan ketelitian menit.
Reset formulir meminta konfirmasi. Batal mempertahankan draft; Reset membersihkan
teks/error, mengembalikan kategori ke Full-Time, waktu mulai ke nilai awal saat
halaman dibuka, dan waktu selesai menjadi kosong. Fitur ini hanya mengubah draft.

Komponen DateTimeFormField menggabungkan hasil [showDatePicker](https://pub.dev/documentation/material_ui/latest/material_ui/showDatePicker.html)
dan [showTimePicker](https://pub.dev/documentation/material_ui/latest/material_ui/showTimePicker.html)
sebelum memperbarui nilai FormField. Data belum dikirim ke API. Validasi lokal
tidak menggantikan pembersihan teks, validasi, dan permission backend.

## Navigation

Drawer yang sama tersedia di Home, form Project, dan form Experience.
Memilih halaman aktif cukup menutup drawer,
sehingga draft tidak hilang. Berpindah ke tujuan lain menutup drawer dan
memakai `pushReplacement`; kartu Tambah Proyek menampilkan SnackBar lalu
memakai `push`, begitu pula kartu Tambah Pengalaman. Kedua form menyediakan
tombol Back saat dibuka dari kartu, serta drawer untuk kembali ke Home.

| Alur | Hasil riwayat |
| --- | --- |
| Home → form melalui kartu | Form ditumpuk di atas Home; Back kembali ke Home yang sama. |
| Home ↔ form melalui drawer dari root | Route teratas diganti; pergantian berulang tidak menambah tumpukan. |
| Home → form lewat kartu → Home lewat drawer | Form diganti Home baru; Home sebelumnya tetap di bawah dan dapat dijangkau dengan Back. |

`pushReplacement` mengganti satu route teratas, bukan membersihkan seluruh
riwayat. Rujukan: [navigasi dan Back](https://docs.flutter.dev/cookbook/navigation/navigation-basics)
serta [pushReplacement](https://api.flutter.dev/flutter/widgets/Navigator/pushReplacement.html).

## Pertanyaan Reflektif

### Tugas 7

Jawaban ini merujuk pada checkpoint Tugas 7 (`de6f8b3`). Perubahan sesudahnya
dicatat pada Development Progress dan Project Form.

1. **Widget tree dan hubungan parent–child**

   Widget tree adalah susunan hierarkis widget yang mendeskripsikan antarmuka.
   Sebuah parent menyusun child melalui properti seperti `child`, `children`,
   atau `home`. Widget kecil dapat digabungkan menjadi komponen dan halaman.
   Contoh sebagian pohon aplikasi ini:

   ```text
   MyApp
   └── MaterialApp
       └── MyHomePage
           └── Scaffold
               ├── AppBar
               └── LayoutBuilder
                   └── SingleChildScrollView
                       └── Center → ConstrainedBox → Padding → Column
                           ├── _ProfileCards → InfoCard
                           ├── PortfolioIntro
                           ├── GridView → ItemCard
                           ├── PortfolioAbout
                           └── PortfolioFooter
   ```

   Pada layout, parent memberikan batas ukuran kepada child. Child menentukan
   ukuran dalam batas tersebut, lalu parent menentukan posisinya. Karena itu,
   lebar kartu dipengaruhi ruang dari parent, bukan hanya ukuran layar perangkat.
   `LayoutBuilder` saya gunakan untuk memilih susunan kartu berdasarkan ruang
   yang tersedia. Rujukan: [arsitektur widget](https://docs.flutter.dev/resources/architectural-overview)
   dan [aturan constraints](https://docs.flutter.dev/ui/layout/constraints).

2. **Widget yang digunakan dan fungsinya**

   Berikut widget yang ditulis langsung dalam kode aplikasi, dikelompokkan
   berdasarkan tanggung jawabnya. Widget internal yang dibuat otomatis oleh
   framework tidak dihitung sebagai komponen buatan proyek.

   | Widget buatan proyek | Fungsi |
   | --- | --- |
   | `MyApp` | Mengatur MaterialApp, tema, dan halaman awal. |
   | `MyHomePage` | Menyusun halaman utama portofolio. |
   | `_ProfileCards` | Mengatur posisi tiga kartu identitas sesuai ruang dan skala teks. |
   | `InfoCard` | Menampilkan pasangan judul dan isi informasi. |
   | `ItemCard` | Menampilkan ikon/nama aksi dan menangani penekanan kartu. |
   | `PortfolioIntro` | Menampilkan sapaan, ringkasan profil, dan tekstur latar. |
   | `PortfolioAbout` | Menampilkan foto, bio, serta program studi pada panel navy. |
   | `PortfolioFooter` | Menampilkan identitas pemilik dan institusi di bagian bawah. |

   | Widget Flutter | Fungsi dalam proyek |
   | --- | --- |
   | `MaterialApp` | Menyediakan konfigurasi aplikasi Material dan halaman awal. |
   | `Scaffold` | Menyediakan kerangka halaman untuk AppBar, body, dan SnackBar. |
   | `AppBar` | Menampilkan nama pemilik pada header. |
   | `Text` | Menampilkan identitas, judul, bio, label, dan pesan. |
   | `Icon` | Menampilkan ikon aksi serta penanda arah pada kartu horizontal. |
   | `Row` | Menyusun widget secara horizontal. |
   | `Column` | Menyusun widget secara vertikal. |
   | `Expanded` | Membagikan ruang tersisa pada anak Row. |
   | `Center` | Memusatkan child dalam ruang yang tersedia. |
   | `ConstrainedBox` | Membatasi lebar konten agar tetap nyaman pada layar lebar. |
   | `SizedBox` | Memberikan ukuran atau jarak antarbagian. |
   | `Padding` | Memberikan ruang di sekeliling child. |
   | `LayoutBuilder` | Membaca constraints parent untuk memilih susunan responsif. |
   | `SingleChildScrollView` | Membuat seluruh isi halaman dapat digulir. |
   | `GridView.count` | Menata kartu aksi dalam satu atau tiga kolom. |
   | `Card` | Menjadi permukaan kartu identitas dengan garis tepi. |
   | `Material` | Menjadi permukaan berwarna tempat efek tinta InkWell digambar. |
   | `InkWell` | Menangani tap, fokus keyboard, dan efek sentuhan kartu aksi. |
   | `SnackBar` | Menampilkan umpan balik setelah aksi ditekan. |
   | `Semantics` | Menandai peran tombol dan heading untuk teknologi bantu. |
   | `ClipRRect` | Memotong foto dan panel mengikuti sudut membulat. |
   | `Stack` | Menumpuk gambar latar dan konten di atasnya. |
   | `Positioned.fill` | Membuat gambar latar memenuhi area Stack. |
   | `Opacity` | Mengurangi intensitas gambar latar. |
   | `Image.asset` | Memuat foto dan tekstur dari aset lokal. |
   | `ColoredBox` | Memberikan warna dasar navy pada panel About. |
   | `Container` | Menggabungkan ukuran, padding, dan dekorasi bingkai foto. |
   | `AspectRatio` | Menjaga rasio tampilan foto 4:5. |
   | `DecoratedBox` | Menggambar garis pembatas footer. |

   Selain itu, `Theme` dan `MediaQuery` diakses melalui `Theme.of(context)` dan
   `MediaQuery.textScalerOf(context)` untuk membaca tema serta skala teks.
   `ScaffoldMessenger` diakses melalui `.of(context)` untuk mengelola SnackBar;
   widget pendukung ini disediakan oleh framework pada pohon aplikasi.

   `ItemHomepage` adalah model data Dart. `ThemeData`, `ColorScheme`,
   `TextStyle`, dan `EdgeInsets` adalah objek konfigurasi, bukan widget.
   `LicenseRegistry` juga bukan widget; fungsinya mendaftarkan lisensi font.
   Rujukan umum: [katalog widget Flutter](https://docs.flutter.dev/ui/widgets).

3. **Fungsi MaterialApp**

   `MaterialApp` menyediakan konfigurasi dan dukungan yang umum dibutuhkan
   aplikasi Material, seperti tema, halaman awal, navigasi, serta lokalisasi.
   Dengan konfigurasi di bagian atas pohon, widget turunannya dapat membaca
   tema yang sama melalui context. Dalam proyek ini, `MyApp` mengembalikan
   `MaterialApp` dengan `theme: PortfolioTheme.light` dan
   `home: const MyHomePage()`.

   MaterialApp lazim dipakai dekat root agar konfigurasi tersebut berlaku
   untuk seluruh halaman dan komponen Material. Contohnya, `ItemCard` dapat
   menemukan ScaffoldMessenger untuk menampilkan SnackBar. Menempatkan setiap
   kartu dalam MaterialApp tersendiri akan memecah konfigurasi aplikasi tanpa
   kebutuhan. Rujukan: [MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html).

4. **StatelessWidget dan StatefulWidget**

   `StatelessWidget` cocok ketika tampilan ditentukan oleh konfigurasi dan
   context, tanpa state lokal yang perlu diubah. StatelessWidget tetap dapat
   dibangun ulang ketika konfigurasi atau dependensinya berubah. Contohnya,
   `MyHomePage` tetap stateless walaupun susunan kartu menyesuaikan ruang layar
   dan skala teks.

   `StatefulWidget` digunakan ketika komponen perlu memiliki state yang berubah
   selama digunakan, misalnya penghitung atau pilihan filter. Objek widget-nya
   tetap immutable; data yang berubah dikelola dalam objek `State`. Pemanggilan
   `setState()` memberitahukan framework bahwa tampilan perlu dibangun ulang.

   Halaman menu saya tidak lagi memiliki counter. Penekanan kartu cukup meminta
   ScaffoldMessenger menampilkan SnackBar. State untuk efek InkWell, scroll,
   dan SnackBar dikelola oleh komponen framework sehingga tidak memerlukan
   objek State baru pada MyHomePage. Rujukan:
   [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)
   dan [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html).

5. **BuildContext**

   `BuildContext` merupakan referensi ke lokasi widget dalam pohon. Context
   penting karena pencarian dependensi mengikuti lokasi tersebut, misalnya
   `Theme.of(context)` mencari Theme terdekat di antara ancestor widget.
   Context yang diterima `build()` adalah lokasi widget yang sedang dibangun,
   bukan otomatis lokasi semua child yang akan dikembalikan oleh build.

   Dalam proyek ini, context digunakan untuk membaca tipografi dari Theme,
   skala teks dari MediaQuery, dan ScaffoldMessenger pada callback ItemCard.
   ItemCard berada di dalam pohon halaman sehingga dapat menemukan pengelola
   SnackBar di atasnya. Jika suatu pencarian membutuhkan ancestor yang baru
   dibuat di dalam build yang sama, diperlukan context dari child di bawah
   ancestor tersebut. Context juga tidak perlu disimpan sebagai data profil.
   Rujukan: [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html).

6. **Hot reload, hot restart, dan full restart**

   Pada sesi debug, **hot reload** (`r`) memasukkan perubahan Dart dan membangun
   ulang widget sambil mempertahankan state. `main()` dan `initState()` tidak
   dijalankan ulang. Ini cocok untuk perubahan tampilan pada build.
   **Hot restart** (`R`) memulai ulang aplikasi Flutter dan state-nya, sehingga
   kode inisialisasi dijalankan kembali.

   Hot reload tidak cukup untuk perubahan yang memerlukan inisialisasi ulang,
   seperti initializer global/static atau kode baru di main. Contohnya,
   pendaftaran lisensi pada `main()` perlu restart agar dijalankan kembali.
   Perubahan struktur tertentu, seperti parameter generic atau pergantian
   enum menjadi class, juga tidak didukung hot reload.

   **Full restart** menghentikan lalu menjalankan aplikasi kembali. Ini
   diperlukan untuk perubahan kode native seperti Kotlin/Java/Swift/Objective-C.
   Untuk font/aset tugas ini, saya memverifikasi bundle melalui build web baru.
   Build release tidak memakai hot reload; perubahan perlu dibuild kembali.
   Jika hot reload ditolak karena kesalahan kompilasi, kode perlu diperbaiki
   terlebih dahulu. Rujukan: [hot reload Flutter](https://docs.flutter.dev/tools/hot-reload).

## AI Disclosure

Saya menggunakan OpenAI Codex untuk penjelasan konsep, penyiapan proyek,
penyuntingan kode dan dokumentasi, serta pengujian aplikasi. Bantuan dokumentasi
juga mencakup penyusunan dan pemeriksaan jawaban refleksi terhadap kode aktual
serta dokumentasi resmi Flutter. Strategi yang saya gunakan adalah meminta
penjelasan memakai contoh proyek, membatasi perubahan per checkpoint, lalu
memeriksa hasil sebelum commit. Ringkasan topiknya ada pada
[AI prompt log](docs/ai-prompt-log.md).

Hasil AI tetap perlu diperiksa. Contohnya, draf test About sempat menambahkan
handle semantics ekstra yang cleanup-nya tidak sesuai urutan pemeriksaan
framework. Test dikoreksi dengan memakai semantics bawaan testWidgets, lalu
seluruh 15 test lulus. Saya juga mengarahkan pemilihan warna dan desain kembali
ke stylesheet web sendiri saat usulan awal belum sesuai gaya portofolio.
Koreksi tersebut menunjukkan bahwa penjelasan atau kode AI perlu dicocokkan
dengan perilaku nyata, sumber proyek, dan pilihan desain saya. Test serta
pemeriksaan Chrome membantu verifikasi lokal, bukan menjamin seluruh platform
sudah diuji atau tugas sudah dikumpulkan. Commit, push, merge, dan pengumpulan
saya jalankan sendiri.
