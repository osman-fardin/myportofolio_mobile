# AI Prompt Log

Dokumen ini berisi beberapa contoh prompt yang mewakili penggunaan OpenAI Codex
selama Tutorial 08 dan Tugas 7. Prompt diringkas dari percakapan agar lebih
mudah dibaca, bukan transkrip literal. Selain penjelasan konsep, Codex juga
membantu menyunting kode dan dokumentasi serta menjalankan pengujian.
Commit, push, merge, dan pengumpulan saya lakukan sendiri.

## 1. Memahami Flutter dan menyiapkan proyek

**Prompt (ringkasan):**

> Flutter sama Dart itu hubungannya gimana? Bisa bantu jelasin fungsi SDK,
> flutter doctor, dan struktur proyeknya? Untuk aplikasi mobile ini perlu repo
> baru atau bisa digabung sama Django? Bantu juga menyiapkan proyek awal dan
> mengecek aplikasi counter-nya bisa jalan.

**Hasil penggunaan:**

AI menjelaskan bahwa Flutter SDK sudah menyertakan Dart SDK, sedangkan
flutter doctor dipakai untuk memeriksa kesiapan lingkungan pengembangan.
lib/main.dart menjadi titik masuk aplikasi, sementara pubspec.yaml menyimpan
konfigurasi dan dependency. Repo Flutter dipisahkan dari backend Django sesuai
alur proyek mobile ini.

## 2. Merapikan README dan prompt log

**Prompt (ringkasan):**

> README-nya bisa dibuat lebih formal dan sederhana kayak repo portofolio
> Django-ku? Prompt log juga pakai gaya nomor-nomor awal di sana ya: pertanyaan
> yang natural dan hasilnya singkat, nggak perlu semua detail proses dimasukin.

**Hasil penggunaan:**

AI menjelaskan susunan README yang memudahkan pembaca mengenali proyek dan
menjalankannya: deskripsi, identitas, teknologi, setup, struktur, serta cara
pengujian. Catatan percakapan ditempatkan pada prompt log agar README tetap
ringkas dan fokus pada informasi proyek.

## 3. Memisahkan halaman utama

**Prompt (ringkasan):**

> Kalau semua kode masih di main.dart, enaknya dipisah gimana? Bisa jelasin
> bagian mana yang tetap di main.dart dan mana yang masuk menu.dart? Bantu ubah
> halaman utama jadi StatelessWidget dan jelasin kenapa counter-nya tidak
> diperlukan lagi.

**Hasil penggunaan:**

AI menjelaskan bahwa main.dart menjadi titik masuk dan pengatur tema,
sedangkan menu.dart berisi tampilan halaman utama. MyHomePage memakai
StatelessWidget karena halaman menu tidak menyimpan counter atau state lokal
yang berubah. Pemisahan ini membuat tanggung jawab tiap berkas lebih jelas.

## 4. Membuat kartu informasi

**Prompt (ringkasan):**

> Untuk kartu NPM, nama, dan kelas, bisa pakai satu widget yang dipakai ulang?
> Jelasin cara kerja parameter title sama content di InfoCard, terus bantu
> susun ketiga kartunya supaya tetap terbaca di layar kecil.

**Hasil penggunaan:**

AI menjelaskan bahwa title dan content merupakan data yang diterima InfoCard,
sehingga satu widget dapat dipakai untuk NPM, nama, dan kelas dengan isi
berbeda. Expanded membagi ruang dalam Row, sedangkan SingleChildScrollView
membuat konten tetap bisa dijangkau ketika tinggi layar terbatas.

## 5. Membuat menu aksi dan SnackBar

**Prompt (ringkasan):**

> Bedanya ItemHomepage sama ItemCard itu apa? Bantu jelasin dan susun menu
> Lihat Proyek, Tambah Proyek, sama Logout pakai ikon. Pas ditekan, masing-masing
> harus menampilkan SnackBar yang sesuai, dan pesan lama jangan sampai numpuk.

**Hasil penggunaan:**

AI menjelaskan bahwa ItemHomepage menyimpan data nama dan ikon, sementara
ItemCard mengatur tampilannya. Material dan InkWell memberikan respons saat
kartu ditekan. ScaffoldMessenger menampilkan SnackBar sesuai nama tombol,
sedangkan clearSnackBars mencegah pesan sebelumnya mengantre.

## 6. Menyesuaikan warna kartu dengan web portofolio

**Prompt (ringkasan):**

> Tiap kartu harus beda warna, tapi aku mau tetap ikut gaya web portofolioku.
> Bisa pakai palet dari web itu? Jelasin cara menyimpan warna di ItemHomepage
> supaya ItemCard nggak perlu banyak if-else, dan bantu cek teks sama ikonnya
> tetap terbaca.

**Hasil penggunaan:**

AI menjelaskan bahwa warna dapat disimpan sebagai atribut ItemHomepage lalu
dibaca oleh ItemCard, sehingga setiap menu memiliki warna sendiri tanpa
percabangan berdasarkan nama. Palet navy, cloud, dan copper mengikuti web
portofolio. Penjelasan kontras membantu memahami pemilihan teks dan ikon
hitam atau putih agar tetap terbaca pada warna latar yang berbeda.

## 7. Membawa gaya web ke aplikasi Flutter

**Prompt (ringkasan):**

> Aku mau tampilan mobile-nya terasa sama kayak web portofolioku. Bisa jelasin
> cara mengatur tema, font, foto, sama background-nya di Flutter? Susunan
> kartunya juga disesuaikan sama lebar layar, tapi data dan SnackBar tetap ada.

**Hasil penggunaan:**

AI menjelaskan penggunaan ThemeData untuk menyatukan warna dan tipografi,
serta pubspec.yaml untuk mendaftarkan font dan gambar lokal. LayoutBuilder
membaca ruang yang tersedia sehingga kartu bisa disusun vertikal di layar
kecil dan sejajar di layar lebar. Pemisahan bagian intro, About, dan footer
membantu menjaga halaman utama tetap mudah dibaca. Lisensi font ikut
disertakan bersama aset Space Grotesk.

## 8. Memahami pertanyaan reflektif Tugas 7

**Prompt (ringkasan):**

> Bisa jelasin enam pertanyaan refleksi Tugas 7 pakai kode yang ada di proyekku?
> Aku mau tahu hubungan widget tree, MaterialApp, StatelessWidget, context,
> dan hot reload. Untuk daftar widget, bedain juga mana widget dan mana yang
> cuma objek konfigurasi seperti ThemeData.

**Hasil penggunaan:**

AI menjelaskan keenam konsep dengan contoh alur MyApp sampai ItemCard,
penggunaan context untuk tema dan SnackBar, serta perbedaan perubahan tampilan
dengan inisialisasi ulang aplikasi. Daftar widget dicocokkan dengan berkas
halaman, tema, dan bagian portofolio. Dokumentasi resmi Flutter menjadi rujukan
untuk membedakan hot reload, hot restart, dan full restart.
