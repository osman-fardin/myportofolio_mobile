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
