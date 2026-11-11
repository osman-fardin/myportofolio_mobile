# Catatan penggunaan AI

Aku memakai AI sebagai bantuan belajar dan implementasi bertahap. **Prompt
(ringkasan)** merangkum topik percakapan, bukan transkrip pertanyaan persis.
Bantuan edit, pengujian, dan dokumentasi dicatat sesuai yang terjadi. Aku tetap
mereview hasil dan menjalankan commit, push, merge, serta pengumpulan sendiri.

## 1. Audit Tutorial 08 dan menyiapkan proyek Flutter pertama

**Tanggal:** 11 November 2026.

**Prompt (ringkasan):**

> Jelaskan hubungan Flutter SDK dan Dart SDK, fungsi flutter doctor, serta
> pemisahan repositori aplikasi Flutter dari backend Django berdasarkan materi.
> Bantu menyiapkan proyek Flutter secara bertahap, menjelaskan struktur direktori
> dan mekanisme state pada aplikasi counter bawaan, serta memverifikasi hasilnya
> melalui analisis statis, widget test, dan pengujian interaksi di Chrome.

**Hasil penggunaan:**

Aku melanjutkan dengan bantuan AI untuk penjelasan, setup, pengujian, dan
dokumentasi. AI membaca lengkap PDF 32 halaman dan screenshot hasil tutorial,
mengaudit Git/backend lama serta toolchain. Awalnya folder tutorial8 masih
kosong, lalu aku memasukkan PDF. Panduan pribadi README/ROADMAP disimpan di
/Users/pino/pbp/tutorial8, di luar repo aplikasi. Baseline Django mencatat 266
test lulus; kode, data, dan PWS tidak diubah. PR docs Tugas 6 sudah merged di
GitHub, tetapi main lokal belum disinkronkan; fetch yang macet dihentikan.

Flutter 3.47.6 dan Dart 3.13.5 sudah terpasang. Doctor menemukan lisensi Android
belum lengkap dan toolchain Xcode/CocoaPods belum siap. Aku membaca serta
menerima lisensi melalui terminal sendiri, lalu membagikan hasil doctor yang
menunjukkan Android toolchain hijau. AI tidak menyetujui lisensi atau mengubah
konfigurasi toolchain. Xcode/CocoaPods tetap belum lengkap; target awal Chrome.

AI menjelaskan bahwa tutorial meminta repo Flutter terpisah dari Django.
Dengan bantuan CLI, dibuat /Users/pino/myportofolio_mobile melalui flutter
create; Git diinisialisasi pada main tanpa stage atau commit. lib/main.dart
dan test/widget_test.dart masih template counter bawaan; pubspec/lock dan
kerangka seluruh platform juga berasal dari generator. Belum ada menu.dart,
InfoCard, ItemCard, koneksi API, atau fitur autentikasi. README template diganti
dengan setup/progres aktual, dan prompt log ini ditambahkan dengan bantuan AI.

Eksperimen Dart console disimpan di folder panduan pribadi halo_osman.dart,
bukan repo aplikasi; dart run mencetak Halo dari Dart, PBP Gasal 2026/2027!.
Flutter analyze bersih, satu widget test counter lulus, dan format check
lib/test tidak mengubah file. Flutter analyze/test sempat menunggu lock
toolchain saat dijalankan bersamaan, lalu keduanya selesai normal.

Flutter run -d chrome dijalankan dengan host/port lokal untuk pemeriksaan
browser. Playwright mencoba klik Enable accessibility, tetapi placeholder
Flutter berada di luar viewport. Semantics lalu diaktifkan lewat tombol itu
secara programatis; kode aplikasi tidak dimodifikasi. Setelah itu browser
menunjukkan Flutter Demo Home Page, nilai awal 0, dan nilai 1 setelah tombol
Increment diklik. Screenshot diperiksa; log browser hanya memuat pesan startup
pada pemeriksaan ini. Output terminal debug Flutter kemudian memperlihatkan
timeout execution context/Runtime.evaluate selama sesi QA. Counter tetap
berfungsi, tetapi semua log runtime tidak diklaim bersih. Server dan sesi
browser QA dihentikan setelah selesai.

Percobaan patch dokumentasi awal ditolak karena satu path dipakai sebagai
delete dan add sekaligus; tidak ada perubahan dari patch yang ditolak. README
kemudian diperbarui dengan patch update biasa. Ignore diperiksa untuk
.dart_tool, build, .idea, dan android/local.properties. Warning locale shell
tetap ada tanpa menggagalkan analyze/test/format. Tidak ada upgrade SDK atau
dependency tambahan. Hasil ini baru checkpoint bootstrap lokal, bukan bukti
build Android/iOS/macOS, repo publik, push sebelum tenggat, atau submisi SCELE.
Langkah berikutnya adalah review/commit awal olehku, kemudian pisahkan halaman
pada branch fitur. Seluruh Tutorial 08 belum dianggap selesai.

## 2. Merapikan dokumentasi awal

**Tanggal:** 11 November 2026.

**Prompt (ringkasan):**

> Bantu merumuskan ringkasan prompt yang berfokus pada konsep dan verifikasi
> Flutter. Rapikan README agar lebih formal dan sederhana, mengikuti struktur
> README portofolio Django.

**Hasil penggunaan:**

Dengan bantuan AI, ringkasan prompt pertama difokuskan pada SDK, struktur
proyek, state, dan verifikasi. README disederhanakan menjadi deskripsi proyek,
identitas dari README Django, teknologi, setup, struktur, pengujian, progres,
serta disclosure singkat. Detail eksperimen dan kendala tooling tetap tersedia
pada entri pertama. Perubahan ini hanya dokumentasi; kode aplikasi tidak
diubah dan test runtime tidak diulang.

## 3. Memisahkan bootstrap dan halaman utama

**Tanggal:** 11 November 2026.

**Prompt (ringkasan):**

> Jelaskan pemisahan bootstrap aplikasi dan halaman utama, penggunaan
> StatelessWidget untuk halaman tanpa state lokal, serta konfigurasi tema
> Material 3. Bantu menerapkannya secara bertahap dan menyesuaikan widget test.

**Hasil penggunaan:**

Commit bootstrap 3d432c5 dan working tree bersih diperiksa sebelum lanjut.
Dengan bantuan AI, dibuat branch fitur, main.dart
diringkas menjadi entry point/MyApp/tema, dan MyHomePage dipindahkan ke
menu.dart sebagai StatelessWidget. Counter, State, setState, serta tombol
increment dihapus. Tema menggunakan ColorScheme.fromSeed indigo dengan
secondary amber[700] dan Material 3 sesuai materi. Konstruktor const tetap
dipakai karena konfigurasi halaman saat ini tetap. Tampilan hanya judul
MyPortfolio dan sapaan Halo dari MyPortfolio!, belum kartu atau aksi menu.

AI membantu mengedit kode, test, serta dokumentasi dan memeriksa dokumentasi
resmi StatelessWidget/ColorScheme.fromSeed. Test counter diganti dengan test
judul/sapaan halaman, tidak adanya FloatingActionButton, dan tidak ada exception
saat render. Flutter analyze bersih, satu widget test lulus, format check nol
perubahan, dan diff check bersih. Browser tidak diulang pada checkpoint ini;
bukti Chrome counter pada entri pertama tetap bukti historis. Dependency dan
konfigurasi platform tidak berubah. Commit masih aku jalankan sendiri.

Nama branch kemudian disesuaikan menjadi `feat/tutorial-8-basic-flutter`
mengikuti pola branch proyek sebelumnya, sesuai permintaan saya. Commit
pemisahan halaman `679e844` tetap dipertahankan.

## 4. Menyusun kartu informasi dengan widget yang dapat digunakan kembali

**Tanggal:** 11 November 2026.

**Prompt (ringkasan):**

> Jelaskan penggunaan parameter title dan content untuk membuat InfoCard yang
> dapat digunakan kembali. Bantu menyusun tiga kartu identitas dengan Row dan
> Column, menyesuaikan layout terhadap ruang layar, serta menguji isi kartu
> dan keterbacaan pada ukuran layar dan skala teks yang berbeda.

**Hasil penggunaan:**

Dengan bantuan AI, InfoCard ditambahkan pada menu.dart sebagai StatelessWidget
dengan dua parameter wajib untuk menampilkan NPM, nama, dan kelas, serta pesan
sambutan pada halaman utama. Main.dart, dependency, dan platform tidak diubah.
Branch aktif feat/tutorial-8-basic-flutter; catatan pergantian
nama branch yang masih lokal tetap dipertahankan.

Row memakai Expanded untuk membagi lebar yang tersedia setelah padding,
menggantikan perhitungan lebar layar/3.5 pada contoh. SingleChildScrollView
memungkinkan konten digulir saat layar pendek atau teks diperbesar. Browser
menemukan NPM membungkus ke baris kedua; padding horizontal kartu kemudian
dikurangi hingga angka utuh pada lebar 320 px, tanpa mengecilkan font. Padding
vertikal 16 dan elevation 2 tetap dipakai.

Enam widget test memeriksa isi kartu beserta labelnya, penggunaan InfoCard
dengan data berbeda, serta layout 320x568, 390x844, 1280x720, dan 320x240 dengan
teks 200%. Percobaan test awal mengharuskan seluruh sapaan panjang muat pada
layar pendek sekaligus. Asumsi ini dikoreksi: awal teks dapat dijangkau, lalu
akhir teks bisa dicapai lewat scroll, tanpa exception atau overflow horizontal.
Seluruh enam test, analyze, format, dan diff check lulus setelah perubahan.

AI membantu edit, pengujian, dokumentasi, dan pengecekan Chrome melalui Flutter
web-server lokal pada lebar 320/390/1280. Screenshot diperiksa; console yang
diperiksa tidak memuat error/warning. Semantics Flutter diaktifkan untuk
pemeriksaan UI. Server/sesi QA dihentikan, artefak disimpan di /tmp. README
diperbarui secara ringkas. Commit tetap aku jalankan sendiri; menu aksi dan
SnackBar belum dibuat pada checkpoint ini.
