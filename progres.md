# Progres Migrasi: Firebase -> Backend Laravel (`siakad-backend`)

Riwayat: project ini sebelumnya sudah di-refactor ke feature-first clean architecture dengan Firebase (Firestore + Firebase Auth + Firebase Storage + FCM + Crashlytics) sebagai data layer. Sekarang seluruh data layer dipindah ke backend REST API mandiri (`D:/Flutterproject/siakad-backend`, Laravel + JWT + Swagger). **App ini sepenuhnya lepas dari Firebase** (keputusan eksplisit user, termasuk menghapus FCM & Crashlytics).

## Keputusan Migrasi

- **Upload file** (foto profil, bukti bayar tagihan): lewat endpoint baru `POST /api/uploads` di `siakad-backend` (multipart, kembalikan URL publik), menggantikan Firebase Storage.
- **Google Sign-In**: dihapus total. Backend cuma dukung email+password JWT.
- **Data realtime**: semua `Stream` Firestore diganti one-shot fetch (`Future`) + pull-to-refresh (`RefreshIndicator`). Tidak ada polling/websocket.
- **FCM & Crashlytics**: dihapus total bersama seluruh dependency Firebase lain.
- **Sesi login**: JWT token + uid disimpan via `flutter_secure_storage` (`core/services/session_service.dart`), bukan lagi `FirebaseAuth.instance.currentUser`.
- **uid**: sekarang dibuat client-side saat register (`package:uuid`), dikirim ke `POST /api/auth/register`.
- **Reset password**: alur digabung — `POST /api/auth/forgot-password` (kirim OTP) lalu `POST /api/auth/reset-password` (body email+otp+password sekaligus verifikasi & ganti password dalam satu panggilan). Halaman `verify_code_page.dart` cuma validasi format 4 digit secara lokal, verifikasi sungguhan terjadi di panggilan terakhir.

## Status Fitur

| Fitur | Status | Catatan |
|---|---|---|
| core (network, services, constants) | Selesai | `api_client.dart`, `api_config.dart`, `api_paths.dart` (baru); `session_service.dart` (baru); `fcm_service.dart` dihapus; `firestore_paths.dart` dihapus |
| auth | Selesai | Google Sign-In dihapus; `AppUser.fromMap` baca snake_case; register generate uid via uuid; reset password 1x call gabungan |
| profile | Selesai | `ProfileController` fetch-based (`user`, `load()`, `refresh()`) menggantikan `userStream()`; upload foto lewat `POST /api/uploads` lalu `PUT /api/mahasiswa/{uid}` |
| app/app.dart + main.dart | Selesai | Firebase.initializeApp & Crashlytics hook dihapus; `splash_page.dart` cek `SessionService.instance.load()` (async) menggantikan `FirebaseAuth.instance.currentUser` |
| dashboard | Selesai | header profil pakai `ProfileController.user` langsung (bukan StreamBuilder), body dibungkus `RefreshIndicator` |
| jadwal | Selesai | `JadwalKuliah.fromMap` baca snake_case (`mata_kuliah`, `jam_mulai`, `jam_selesai`); `ApiJadwalRepository.fetchJadwal()` (`GET /api/jadwal-kuliah`, array) menggantikan `watchJadwal()` stream; `JadwalController` fetch-based (`jadwalList`, `load()`, `refresh()`); halaman pakai `RefreshIndicator` + baca state langsung |
| krs | Selesai | `Krs.fromMap` baca snake_case (`tahun_akademik`, `mata_kuliah`); `ApiKrsRepository.fetchKrs()` (`GET /api/krs`, ambil item pertama dari array, `null` jika kosong) menggantikan `watchKrs()`; fitur read-only (tidak ada alur submit KRS di UI, jadi `POST /api/krs` tidak dipakai); `KrsController` fetch-based (`krs`, `load()`, `refresh()`); halaman pakai `RefreshIndicator` |
| khs | Selesai | `NilaiMataKuliah.fromMap` baca snake_case (`tahun_akademik`, `mata_kuliah`); `ApiKhsRepository.fetchKhs()` (`GET /api/khs`, array) menggantikan `watchKhs()` stream; `KhsController` fetch-based (`khsList` menggantikan `nilaiList`, `load()`, `refresh()`), `KhsCalculator` dipakai persis sama tanpa perubahan; halaman pakai `RefreshIndicator` |
| tagihan (+ help_bayar/help_transfer/help_upload/confirmation) | Selesai | `ApiTagihanRepository.kirimKonfirmasiPembayaran` upload dulu via `ApiClient.uploadFile(folder: 'tagihan')` lalu `POST /api/tagihan/{id}/konfirmasi` dengan body `{bukti_url, catatan}`. Celah `catatan` yang awalnya ditemukan (endpoint hanya terima `bukti_url`) sudah ditambal: `TagihanController@konfirmasi` di `siakad-backend` sekarang menerima field `catatan` opsional juga (lihat bagian "Perubahan di siakad-backend"). `help_bayar_page.dart`, `help_transfer_page.dart`, `help_upload_page.dart`, `confirmation_page.dart` dicek, semuanya konten statis tanpa dependency Firebase, tidak disentuh. |
| kegiatan | Selesai | `ApiKegiatanRepository.fetchKegiatan()` (global, no uid scoping); `kuota` tetap `String` (backend juga mengirim string); `KegiatanController` fetch-based; `KegiatanPage` pakai `RefreshIndicator`; `DetailKegiatanPage`/`FormDaftarPage`/`KonfirmasiPage` murni UI form lokal tanpa persist, tidak diubah |
| informasi | Selesai | `ApiInformasiRepository.fetchInformasi()` (global, no uid scoping), `tanggal` di-parse dari ISO string; `InformasiController` fetch-based; `InformasiPage` pakai `RefreshIndicator`; `InformasiDetailPage` murni terima entity, tidak diubah |
| notifikasi | Selesai | `ApiNotifikasiRepository.fetchNotifikasi()` + `markAsRead(int id)` lewat `POST /api/notifikasi/{id}/read`; backend auto-scope uid & filter tipe_user; `NotifikasiController` fetch-based dengan `markAsRead` update lokal; `NotifikasiPage` pakai `RefreshIndicator`; `NotifikasiDetailPage` (terima judul/isi string) tidak diubah |
| absensi (index + 6 mata kuliah) | Selesai | `ApiAbsensiRepository` fetch `GET /api/absensi` (auto-scope uid di backend, tidak ada query param filter matkul); filter/grouping per matkul dilakukan client-side (`AbsensiController.groupByMatkul`/`sortedByPertemuan`), sama seperti sebelumnya. 6 halaman per-matkul tetap thin wrapper ke `AbsensiMatkulPage` tanpa perubahan. |
| bantuan | Tidak berubah | form lokal tanpa persist, tidak ada endpoint terkait |
| Hapus dependency Firebase dari `pubspec.yaml` | Selesai | lihat daftar di bawah |
| Hapus `firebase_options.dart` | Selesai | file dihapus |
| Bersihkan `android/app/build.gradle.kts` (plugin google-services/crashlytics) | Selesai | plugin `com.google.gms.google-services` & `com.google.firebase.crashlytics` dihapus dari `build.gradle.kts` & `settings.gradle.kts`; dependency Firebase BoM/crashlytics/analytics dihapus; `google-services.json` dihapus |
| `flutter analyze` bersih | Selesai | `flutter pub get` sukses, `flutter analyze` -> "No issues found!"; tidak ada sisa referensi `firebase`/`cloud_firestore`/`google_sign_in` di `lib/`, `pubspec.yaml`, atau config Android |

## Peta Endpoint (Firestore lama -> Laravel baru)

| Fitur | Lama (Firestore) | Baru (Laravel) |
|---|---|---|
| auth | `users`, `dosen` (cek role), `otp_requests`, EmailJS | `POST /api/auth/register` (role=mahasiswa), `POST /api/auth/login`, `POST /api/auth/forgot-password`, `POST /api/auth/reset-password` |
| profile | `users/{uid}` + Storage `profil_photos/{uid}.jpg` | `GET/PUT /api/mahasiswa/{uid}`, `POST /api/uploads` |
| jadwal | `jadwal_kuliah where uid==` | `GET /api/jadwal-kuliah` |
| krs | `krs where uid==` (ambil 1 doc) | `GET /api/krs` (ambil 1 item), `POST /api/krs` (nested `mata_kuliah`) |
| khs | `khs where uid==` | `GET /api/khs` |
| absensi | `absensi where uid== [and matkul==]` | `GET /api/absensi` (filter matkul di client) |
| tagihan | `tagihan where uid==` + Storage `bukti_tagihan/{uid}/{id}.jpg` | `GET /api/tagihan`, `POST /api/uploads` lalu `POST /api/tagihan/{id}/konfirmasi` |
| informasi | `informasi orderBy tanggal desc` (global) | `GET /api/informasi` |
| kegiatan | `kegiatan orderBy tanggal desc` (global) | `GET /api/kegiatan` |
| notifikasi | `notifikasi where uid== orderBy createdAt desc` + markAsRead | `GET /api/notifikasi`, `POST /api/notifikasi/{id}/read` |
| FCM token | Firestore `users.fcmToken` | dihapus total (FCM dihapus) |

## Dependency Berubah (`pubspec.yaml`)

- **Dihapus**: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_messaging`, `firebase_crashlytics`, `firebase_analytics`, `google_sign_in`, `mailer`.
- **Ditambah**: `flutter_secure_storage: ^9.2.2` (simpan token JWT), `uuid: ^4.5.1` (generate uid saat register).
- **Dipertahankan**: `http`, `image_picker`, `flutter_local_notifications`, `timezone`, `provider`, `ionicons`, `cupertino_icons`.

## Pola Konversi per Fitur (dipakai konsisten di semua fitur data)

- **domain**: entity tetap sama field-nya (camelCase), `fromMap` diubah membaca key JSON snake_case dari Laravel.
- **data**: `FirebaseXRepository` (Firestore `.snapshots()`/`Stream`) -> `ApiXRepository` (`ApiClient.get/post/put`, `Future`), scoping `uid` dihapus dari query (backend auto-scope lewat token JWT).
- **presentation/controllers**: expose `List<T> data`, `bool isLoading`, `String? error`, method `load()`/`refresh()` + `notifyListeners()` — bukan lagi getter `Stream`.
- **presentation/pages**: `StreamBuilder` -> baca state controller langsung + `RefreshIndicator(onRefresh: controller.refresh, ...)`.

## Perubahan di `siakad-backend` (Laravel)

- Tambah `UploadController` + `POST /api/uploads` (multipart, simpan ke `storage/app/public/uploads/{folder}/`, kembalikan URL) — sudah diuji via curl, berfungsi.
- `storage:link` sudah dijalankan.
- `TagihanController@konfirmasi` ditambah dukungan field opsional `catatan` (sebelumnya cuma `bukti_url`), supaya mahasiswa bisa persist catatan saat konfirmasi bayar.
- `APP_URL` diperbaiki jadi `http://localhost:8000` (sebelumnya tanpa port) supaya URL hasil upload benar saat diakses.

## Verifikasi yang Sudah Dilakukan

Tidak ada emulator/device Flutter di lingkungan pengerjaan ini, jadi verifikasi dilakukan lewat `flutter analyze` (bersih, 0 issue) + pengujian kontrak API langsung via `curl` terhadap `siakad-backend` yang berjalan (`php artisan serve`):
- Register mahasiswa baru -> login -> dapat JWT: **berhasil**.
- `GET` ke `jadwal-kuliah`, `krs`, `khs`, `tagihan`, `informasi`, `kegiatan`, `notifikasi`, `absensi` dengan token: **semua 200**.
- Alur `forgot-password` (dapat OTP dev) -> `reset-password` (OTP+password sekaligus) -> login dengan password baru: **berhasil**.
- Upload file (`POST /api/uploads`) -> update `photo_url` mahasiswa via `PUT`: **berhasil**, URL bisa diakses (200).

Yang **belum** bisa diverifikasi di lingkungan ini (butuh emulator/device Flutter sungguhan): render UI aktual, alur navigasi antar halaman, `image_picker` (kamera/galeri asli), perilaku `RefreshIndicator` visual, dan penyimpanan token di `flutter_secure_storage` di device asli. User perlu menjalankan app di emulator/device untuk uji end-to-end penuh, dengan `ApiConfig.baseUrl` di `lib/core/constants/api_config.dart` disesuaikan (default `http://10.0.2.2:8000/api` untuk emulator Android; ganti ke IP LAN untuk device fisik, atau `http://localhost:8000/api` untuk iOS simulator).

Konfigurasi Firebase di iOS/platform lain (`ios/Runner/GoogleService-Info.plist` jika ada, dsb) tidak disentuh sesi ini karena tidak bisa diverifikasi/build di lingkungan Windows saat ini — perlu dibersihkan manual oleh user jika akan build ke iOS.
