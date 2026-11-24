# AI Prompt Log

Dokumen ini memuat ringkasan pertanyaan dan penjelasan konsep dari diskusi
dengan OpenAI Codex selama Tutorial 08–10 dan Tugas 7–8. Prompt disajikan
sebagai ringkasan topik pembelajaran, bukan transkrip literal percakapan.

## 1. Memahami Flutter dan menyiapkan proyek

**Prompt (ringkasan):**

> Apa hubungan antara Flutter dan Dart dalam pengembangan aplikasi?
> Jelaskan fungsi Flutter SDK, flutter doctor, dan struktur dasar proyek.
> Mengapa kode Flutter dan backend Django ditempatkan pada repositori terpisah?

**Hasil penggunaan:**

AI menjelaskan bahwa Flutter SDK sudah menyertakan Dart SDK, sedangkan
flutter doctor dipakai untuk memeriksa kesiapan lingkungan pengembangan.
lib/main.dart menjadi titik masuk aplikasi, sementara pubspec.yaml menyimpan
konfigurasi dan dependency. Repo Flutter dipisahkan dari backend Django sesuai
alur proyek mobile ini.

## 2. Memahami struktur dokumentasi proyek

**Prompt (ringkasan):**

> Bagaimana struktur README yang membantu pembaca memahami dan menjalankan
> proyek Flutter? Jelaskan informasi yang perlu dicantumkan serta perbedaan
> fungsi README dan catatan pembelajaran.

**Hasil penggunaan:**

AI menjelaskan bahwa README menyajikan deskripsi, identitas, teknologi,
petunjuk menjalankan aplikasi, struktur berkas, dan pengujian. Catatan
pembelajaran memuat pertanyaan serta penjelasan konsep. Pembagian ini membantu
pembaca menemukan informasi proyek dan materi pembelajaran sesuai kebutuhan.

## 3. Memisahkan halaman utama

**Prompt (ringkasan):**

> Bagaimana pembagian tanggung jawab antara main.dart dan halaman utama
> aplikasi? Jelaskan alasan penggunaan StatelessWidget pada halaman menu
> yang tidak memiliki state lokal yang berubah.

**Hasil penggunaan:**

AI menjelaskan bahwa main.dart menjadi titik masuk dan pengatur tema,
sedangkan menu.dart berisi tampilan halaman utama. MyHomePage memakai
StatelessWidget karena halaman menu tidak menyimpan counter atau state lokal
yang berubah. Pemisahan ini membuat tanggung jawab tiap berkas lebih jelas.

## 4. Membuat kartu informasi

**Prompt (ringkasan):**

> Bagaimana parameter widget memungkinkan InfoCard digunakan untuk beberapa
> jenis informasi? Jelaskan fungsi title dan content serta peran Expanded
> dan SingleChildScrollView dalam penyusunan tata letak.

**Hasil penggunaan:**

AI menjelaskan bahwa title dan content merupakan data yang diterima InfoCard,
sehingga satu widget dapat dipakai untuk NPM, nama, dan kelas dengan isi
berbeda. Expanded membagi ruang dalam Row, sedangkan SingleChildScrollView
membuat konten tetap bisa dijangkau ketika tinggi layar terbatas.

## 5. Membuat menu aksi dan SnackBar

**Prompt (ringkasan):**

> Apa perbedaan tanggung jawab ItemHomepage dan ItemCard?
> Jelaskan hubungan Material, InkWell, dan ScaffoldMessenger dalam memberikan
> umpan balik interaksi. Bagaimana clearSnackBars mengatur antrean pesan?

**Hasil penggunaan:**

AI menjelaskan bahwa ItemHomepage menyimpan data nama dan ikon, sementara
ItemCard mengatur tampilannya. Material dan InkWell memberikan respons saat
kartu ditekan. ScaffoldMessenger menampilkan SnackBar sesuai nama tombol,
sedangkan clearSnackBars mencegah pesan sebelumnya mengantre.

## 6. Menyesuaikan warna kartu dengan web portofolio

**Prompt (ringkasan):**

> Bagaimana atribut warna pada ItemHomepage mengatur tampilan setiap kartu
> melalui satu widget yang dapat digunakan kembali? Jelaskan hubungan palet
> warna portofolio dengan pemilihan warna teks dan ikon yang mudah dibaca.

**Hasil penggunaan:**

AI menjelaskan bahwa warna dapat disimpan sebagai atribut ItemHomepage lalu
dibaca oleh ItemCard, sehingga setiap menu memiliki warna sendiri tanpa
percabangan berdasarkan nama. Palet navy, cloud, dan copper mengikuti web
portofolio. Penjelasan kontras membantu memahami pemilihan teks dan ikon
hitam atau putih agar tetap terbaca pada warna latar yang berbeda.

## 7. Membawa gaya web ke aplikasi Flutter

**Prompt (ringkasan):**

> Bagaimana ThemeData dan deklarasi aset pada pubspec.yaml menjaga konsistensi
> visual aplikasi? Jelaskan penggunaan LayoutBuilder untuk menyesuaikan
> susunan kartu dengan ruang yang tersedia.

**Hasil penggunaan:**

AI menjelaskan penggunaan ThemeData untuk menyatukan warna dan tipografi,
serta pubspec.yaml untuk mendaftarkan font dan gambar lokal. LayoutBuilder
membaca ruang yang tersedia sehingga kartu bisa disusun vertikal di layar
kecil dan sejajar di layar lebar. Pemisahan bagian intro, About, dan footer
membantu menjaga halaman utama tetap mudah dibaca. Lisensi font ikut
disertakan bersama aset Space Grotesk.

## 8. Memahami pertanyaan reflektif Tugas 7

**Prompt (ringkasan):**

> Bagaimana hubungan widget tree, MaterialApp, StatelessWidget, dan
> BuildContext pada aplikasi ini? Jelaskan perbedaan widget dan objek
> konfigurasi seperti ThemeData, serta perbedaan hot reload dan hot restart.

**Hasil penggunaan:**

AI menjelaskan konsep tersebut dengan contoh alur MyApp sampai ItemCard,
penggunaan context untuk tema dan SnackBar, serta perbedaan perubahan tampilan
dengan inisialisasi ulang aplikasi. Daftar widget dicocokkan dengan berkas
halaman, tema, dan bagian portofolio. Dokumentasi resmi Flutter menjadi rujukan
untuk membedakan hot reload, hot restart, dan full restart.

## 9. Memahami perubahan pustaka Material

**Prompt (ringkasan):**

> Apa peran paket material_ui pada versi Flutter yang digunakan proyek ini?
> Jelaskan hubungan pubspec.yaml dan pubspec.lock serta alasan penyesuaian
> impor perlu dilakukan pada kode aplikasi dan pengujian.

**Hasil penggunaan:**

AI menjelaskan bahwa material_ui menyediakan komponen Material sebagai paket
terpisah dari Flutter SDK. Paket ditambahkan melalui pubspec.yaml, sedangkan
pubspec.lock mencatat versi hasil resolusi dependency. Impor pada aplikasi dan
test perlu disesuaikan bersama karena komponen dari dua pustaka dapat memiliki
tipe yang berbeda. Penyesuaian ini tidak memerlukan pembaruan Flutter SDK.

## 10. Memisahkan halaman dan kartu aksi

**Prompt (ringkasan):**

> Bagaimana pemisahan folder screens dan widgets memperjelas tanggung jawab
> kode? Jelaskan penempatan ItemHomepage bersama ItemCard serta pengaruh
> pemindahan berkas terhadap referensi impor.

**Hasil penggunaan:**

AI menjelaskan bahwa screens menyusun halaman, sedangkan widgets menampung
komponen antarmuka yang dapat dipakai ulang. ItemHomepage ditempatkan bersama
ItemCard karena menjadi data yang diterima kartu, sehingga keduanya tidak
perlu mengimpor halaman utama. Referensi pada main.dart dan test ikut mengikuti
lokasi baru. Pemisahan berkas mempertahankan tampilan dan perilaku SnackBar.

## 11. Memahami form, validasi, dan ringkasan proyek

**Prompt (ringkasan):**

> Bagaimana hubungan StatefulWidget, Form, GlobalKey, validator, dan onSaved
> pada formulir Project? Jelaskan pengelolaan pilihan jenis proyek,
> penyajian ringkasan isian, serta pemulihan nilai awal setelah konfirmasi.

**Hasil penggunaan:**

AI menjelaskan bahwa validator memeriksa input, sedangkan onSaved mengambil
nilai setelah form valid. GlobalKey memberi akses ke validate, save, dan reset;
state menyimpan pilihan jenis proyek yang menentukan munculnya input tambahan.
Key pada kelompok field menjaga isian ketika susunan widget berubah. Pada
tahap Tutorial 09, dialog menampilkan ringkasan lokal dan konfirmasi OK
mereset field serta pilihan. Integrasi penyimpanan API dibahas pada entri
Tutorial 10.

## 12. Memahami drawer dan riwayat navigasi

**Prompt (ringkasan):**

> Apa perbedaan Navigator.push, pushReplacement, dan pop terhadap stack
> navigasi? Jelaskan pengaruhnya pada tombol kembali serta alasan pemilihan
> halaman aktif pada drawer perlu mempertahankan isian formulir.

**Hasil penggunaan:**

AI menjelaskan bahwa push menambahkan halaman pada stack, sedangkan
pushReplacement mengganti halaman teratas. Drawer ditutup sebelum berpindah;
memilih tujuan yang sama hanya menutup drawer. Karena route di bawahnya tidak
ikut dihapus, gabungan navigasi kartu dan drawer dapat menyisakan Home lama
untuk dikunjungi lewat Back. Kartu tetap memberi feedback SnackBar sebelum
membuka form, dan form menyediakan akses Back serta drawer.

## 13. Memahami aturan input pengalaman

**Prompt (ringkasan):**

> Bagaimana aturan model Experience pada Django menjadi acuan validasi
> formulir Flutter? Jelaskan validasi field wajib, kategori, thumbnail
> opsional, dan urutan waktu. Mengapa logika validasi dipisahkan dari widget?

**Hasil penggunaan:**

AI menjelaskan pemetaan field Experience ke aturan input lokal. Enam nilai
kategori mengikuti backend, sedangkan waktu selesai yang kosong berarti
pengalaman masih berlangsung. Perbandingan tanggal juga memperhatikan jam,
bukan hanya hari. Fungsi validasi dipisahkan dari tampilan agar batas teks,
URL, serta urutan waktu dapat diuji tanpa membuka halaman. Backend tetap
memvalidasi dan memeriksa permission saat integrasi API diterapkan nanti.

## 14. Memahami field tanggal dan jam pada form

**Prompt (ringkasan):**

> Bagaimana FormField<DateTime> menggabungkan pemilihan tanggal dan jam
> menjadi satu nilai? Jelaskan penanganan pembatalan picker serta validasi
> ulang waktu selesai ketika waktu mulai berubah.

**Hasil penggunaan:**

AI menjelaskan penggunaan FormField<DateTime> untuk menggabungkan dua picker
menjadi satu nilai form. Nilai baru diterapkan setelah tanggal dan jam
dikonfirmasi, sedangkan pembatalan mempertahankan draft. Validator waktu
selesai membaca nilai mulai terbaru. Simpan menjalankan validasi dan mengambil
snapshot isian untuk dialog, sementara OK menutup dialog tanpa menghapus draft.

## 15. Menghubungkan form pengalaman ke navigasi

**Prompt (ringkasan):**

> Bagaimana kartu aksi dan drawer menyediakan navigasi ke formulir Experience?
> Jelaskan perbedaan perpindahan route pada keduanya serta penyesuaian
> susunan kartu terhadap lebar layar dan ukuran teks.

**Hasil penggunaan:**

AI menjelaskan penambahan tujuan navigasi yang eksplisit pada drawer bersama.
Kartu memakai push agar pengguna dapat kembali ke Home, sementara drawer
mengganti halaman teratas melalui pushReplacement. Pilihan halaman aktif
hanya menutup drawer. Susunan empat kartu menjadi satu, dua, atau empat kolom
sesuai ruang yang tersedia, dengan satu kolom saat teks diperbesar.

## 16. Memahami reset formulir dengan konfirmasi

**Prompt (ringkasan):**

> Mengapa reset formulir memerlukan konfirmasi pengguna? Jelaskan peran
> FormState.reset dalam memulihkan teks, kategori, tanggal, dan pesan
> validasi, serta penanganan pembatalan reset.

**Hasil penggunaan:**

AI menjelaskan dialog konfirmasi yang mengembalikan keputusan pengguna.
FormState.reset memulihkan field, termasuk dropdown dan FormField<DateTime>,
sedangkan state kategori yang dipakai ringkasan ikut dikembalikan ke default.
Pembatalan tidak mengubah draft. Reset hanya memengaruhi isian lokal dan tidak
menghapus data portofolio.

## 17. Memahami navigasi, tata letak, dan validasi formulir

**Prompt (ringkasan):**

> Bagaimana navigasi, tema bersama, dan susunan formulir mendukung penggunaan
> aplikasi pada layar sempit? Jelaskan perbedaan bantuan keyboard atau picker
> dengan validasi input, serta peran widget test dalam memeriksa perilakunya.

**Hasil penggunaan:**

AI menjelaskan hubungan stack navigasi, drawer bersama, dan tema antarhalaman.
Layout yang dapat digulir menjaga field tetap terjangkau saat layar sempit
atau keyboard terbuka. Keyboard dan picker membantu pengisian, sedangkan
validator memeriksa aturan input. Widget test memeriksa interaksi seperti
pembatalan picker, validasi ulang, navigasi, dan reset.

## 18. Memahami JSON dan pemanggilan API

**Prompt (ringkasan):**

> Bagaimana data JSON dari API Django dipetakan menjadi objek Project di Flutter?
> Jelaskan fungsi json_serializable dan pemisahan permintaan HTTP melalui
> ApiClient. Bagaimana FutureBuilder menampilkan data serta menangani kondisi
> pemuatan, kegagalan, dan daftar kosong?

**Hasil penggunaan:**

AI menjelaskan pemetaan nama field JSON ke atribut model Dart serta fungsi
fromJson dan toJson. ApiClient menangani komunikasi HTTP, sedangkan
FutureBuilder menyusun tampilan berdasarkan hasil permintaan. Future disimpan
pada State agar rebuild tidak mengulang permintaan; refresh memperbarui Future
tersebut. Field yang dikelola server tidak disertakan dalam payload POST.

## 19. Memahami sesi token dan guard form

**Prompt (ringkasan):**

> Apa perbedaan autentikasi token dan sesi pada Django? Jelaskan peran
> AuthState dan provider dalam menyimpan status login serta membatasi akses
> formulir Project. Mengapa respons 401 dan 403 perlu ditangani secara berbeda?

**Hasil penggunaan:**

AI menjelaskan bahwa autentikasi mengenali pengguna, sedangkan permission
menentukan operasi yang diizinkan. AuthState menyimpan token di memori dan
provider meneruskan perubahan status login ke antarmuka. Respons 401 memerlukan
autentikasi ulang, sementara 403 menunjukkan penolakan izin. Pembatasan formulir
pada antarmuka tetap harus disertai pemeriksaan permission oleh server.

## 20. Memahami CI dan artifact APK

**Prompt (ringkasan):**

> Bagaimana alur continuous integration pada Flutter menggunakan
> very_good_workflows dan GitHub Actions? Jelaskan fungsi code generation,
> hubungan needs antara job pengujian dan build APK, serta penyimpanan APK
> sebagai artifact. Apa yang dibuktikan oleh build lokal dan workflow remote?

**Hasil penggunaan:**

AI menjelaskan bahwa kode model perlu dihasilkan sebelum analisis, pengujian,
dan build karena berkas generated tidak disimpan dalam Git. needs membuat job
APK menunggu keberhasilan job sebelumnya, sedangkan artifact menyimpan hasil
build agar dapat diunduh. Build lokal memeriksa lingkungan pengembangan;
keberhasilan workflow remote perlu diperiksa melalui GitHub Actions.

## 21. Memahami gambar publik lintas origin pada Flutter Web

**Prompt (ringkasan):**

> Mengapa gambar static Django dapat gagal ditampilkan di Flutter Web meskipun
> permintaan data API berhasil? Jelaskan hubungan CORS dengan pemakaian gambar
> pada canvas serta fungsi WebHtmlElementStrategy untuk gambar publik.

**Hasil penggunaan:**

AI menjelaskan bahwa izin CORS pada endpoint API tidak otomatis berlaku pada
berkas static. Pemakaian gambar lintas origin pada canvas memerlukan izin yang
sesuai dari server gambar. WebHtmlElementStrategy.prefer menampilkan gambar
publik melalui elemen HTML, sehingga kebijakan CORS backend tetap dapat
dibatasi pada API. Token autentikasi tidak disertakan pada URL gambar.
