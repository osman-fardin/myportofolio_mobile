# AI Prompt Log

Dokumen ini berisi beberapa contoh prompt yang mewakili penggunaan OpenAI Codex
selama Tutorial 08, Tugas 7, dan Tutorial 09. Prompt diringkas dari percakapan agar lebih
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

## 9. Memahami perubahan pustaka Material

**Prompt (ringkasan):**

> Di materi, import Material sekarang pakai material_ui. Bedanya dengan import
> sebelumnya apa? Bisa jelasin cara menyesuaikannya dengan versi Flutter yang
> kupakai dan bantu cek supaya tema serta fitur lama tetap berjalan?

**Hasil penggunaan:**

AI menjelaskan bahwa material_ui menyediakan komponen Material sebagai paket
terpisah dari Flutter SDK. Paket ditambahkan melalui pubspec.yaml, sedangkan
pubspec.lock mencatat versi hasil resolusi dependency. Impor pada aplikasi dan
test perlu disesuaikan bersama karena komponen dari dua pustaka dapat memiliki
tipe yang berbeda. Penyesuaian ini tidak memerlukan pembaruan Flutter SDK.

## 10. Memisahkan halaman dan kartu aksi

**Prompt (ringkasan):**

> Kalau halaman dipindah ke folder screens dan ItemCard ke widgets, import
> mana saja yang perlu disesuaikan? ItemHomepage sebaiknya ditaruh di mana
> supaya kartu tidak bergantung pada halaman utama?

**Hasil penggunaan:**

AI menjelaskan bahwa screens menyusun halaman, sedangkan widgets menampung
komponen antarmuka yang dapat dipakai ulang. ItemHomepage ditempatkan bersama
ItemCard karena menjadi data yang diterima kartu, sehingga keduanya tidak
perlu mengimpor halaman utama. Referensi pada main.dart dan test ikut mengikuti
lokasi baru. Pemisahan berkas mempertahankan tampilan dan perilaku SnackBar.

## 11. Memahami form, validasi, dan ringkasan proyek

**Prompt (ringkasan):**

> Gimana cara membuat form sesuai field Project-ku? Jelasin hubungan
> StatefulWidget, Form, GlobalKey, validator, dan onSaved. Aku juga perlu
> dropdown yang tetap bisa diisi jenis lain, dialog ringkasan, dan reset
> setelah OK tanpa membawa data proyek sebelumnya.

**Hasil penggunaan:**

AI menjelaskan bahwa validator memeriksa input, sedangkan onSaved mengambil
nilai setelah form valid. GlobalKey memberi akses ke validate, save, dan reset;
state menyimpan pilihan jenis proyek yang menentukan munculnya input tambahan.
Key pada kelompok field menjaga isian ketika susunan widget berubah. Dialog
menerima ringkasan input sementara, lalu konfirmasi OK mereset field dan pilihan
bersama. Belum ada penyimpanan data ke backend.

## 12. Memahami drawer dan riwayat navigasi

**Prompt (ringkasan):**

> Kenapa tombol Tambah Proyek memakai push, tapi drawer memakai
> pushReplacement? Jelasin efeknya ke Back. Gimana supaya memilih halaman
> yang sedang dibuka tidak menghapus draft dan SnackBar tetap berfungsi?

**Hasil penggunaan:**

AI menjelaskan bahwa push menambahkan halaman pada stack, sedangkan
pushReplacement mengganti halaman teratas. Drawer ditutup sebelum berpindah;
memilih tujuan yang sama hanya menutup drawer. Karena route di bawahnya tidak
ikut dihapus, gabungan navigasi kartu dan drawer dapat menyisakan Home lama
untuk dikunjungi lewat Back. Kartu tetap memberi feedback SnackBar sebelum
membuka form, dan form menyediakan akses Back serta drawer.
