# Progres Migrasi: Firebase -> Backend Laravel (`siakad-backend`)

Riwayat: project ini sebelumnya sudah di-refactor ke feature-first clean architecture dengan Firebase (Firestore + Firebase Auth + FCM + Crashlytics + Analytics — tidak pernah pakai Firebase Storage/Google Sign-In untuk login sungguhan) sebagai data layer. Sekarang seluruh data layer dipindah ke backend REST API mandiri yang sama dengan yang dipakai `sistem_akademik` (`D:/Flutterproject/siakad-backend`, Laravel + JWT + Swagger). **App ini sepenuhnya lepas dari Firebase.**

## Keputusan Migrasi (konsisten dengan migrasi `sistem_akademik` sebelumnya)

- **Google Sign-In**: dihapus (`google_sign_in` cuma dipakai untuk `signOut()` cleanup saat logout, tidak pernah ada alur login Google sungguhan di app ini).
- **Data realtime**: semua `Stream` Firestore diganti one-shot fetch (`Future`) + pull-to-refresh (`RefreshIndicator`).
- **FCM, Crashlytics, Analytics**: dihapus total bersama seluruh dependency Firebase lain.
- **Sesi login**: JWT token + uid disimpan via `flutter_secure_storage` (`core/services/session_service.dart`).
- **`app/app.dart`**: sebelumnya route berdasarkan `FirebaseAuth.instance.currentUser` (sinkron, tanpa splash). Sekarang `_AuthGate` (StatefulWidget baru di `app/app.dart`) memuat `SessionService.instance.load()` (async) dengan indikator loading singkat, baru memutuskan `HomePage`/`LoginPage`.
- **Reset password**: dulu pakai `FirebaseAuth.sendPasswordResetEmail` (kirim link ke email asli via Firebase). Sekarang pakai alur OTP yang sama dengan `sistem_akademik`: `POST /api/auth/forgot-password` -> `VerifyCodePage` (baru, validasi format 4 digit lokal) -> `NewPasswordPage` (baru) -> `POST /api/auth/reset-password` (email+otp+password sekaligus).
- **Ganti password (`ubah_password_page.dart`)**: dulu pakai `reauthenticateWithCredential` + `updatePassword` (Firebase Auth). **Backend `siakad-backend` ditambah endpoint baru** `POST /api/auth/change-password` (body `old_password`+`new_password`, verifikasi via `Hash::check` lalu update) khusus untuk kebutuhan ini — endpoint ini tidak ada sebelumnya karena `sistem_akademik` tidak butuh fitur ganti-password-saat-login (cuma forgot-password).
- **Composite-key path encoding**: `kelas`/`pertemuan` dipakai sebagai path segment URL (`/api/nilai/{kelas}/{mahasiswaUid}`, `/api/presensi/{kelas}/{pertemuan}/{mahasiswaUid}`) dan sering mengandung spasi (mis. "Mobile Computing A1"). **Tidak lagi disanitasi jadi underscore** seperti pola lama di Firestore (`_sanitize` di `nilai_repository.dart`/`presensi_repository.dart`) — sekarang di-`Uri.encodeComponent()` di `ApiPaths.nilaiItem()`/`ApiPaths.presensiItem()` supaya nilai kolom `kelas` di database tetap string asli apa adanya, cuma di-encode saat jadi bagian URL. Sudah diuji lewat curl dengan kelas "Mobile Computing A1", berhasil.
- **Fallback mahasiswa-by-kelas**: pola lama (query `users where kelas==X`, kalau kosong fallback ke semua `users`) dipertahankan, tapi dieksekusi client-side (2 panggilan `GET /api/mahasiswa?kelas=X` lalu `GET /api/mahasiswa` kalau hasil pertama kosong) karena endpoint backend tidak melakukan fallback otomatis.

## Status Fitur

| Fitur | Status | Catatan |
|---|---|---|
| core (network, services, constants) | Selesai | `api_client.dart`, `api_config.dart`, `api_paths.dart` (baru, termasuk path builder ter-encode untuk nilai/presensi); `session_service.dart` (baru); `fcm_service.dart` dihapus; `firestore_paths.dart` dihapus |
| auth | Selesai | Google Sign-In dihapus; `Dosen.fromMap` baca snake_case (`photo_url`); alur reset password jadi 3 halaman (forgot -> verify_code (baru) -> new_password (baru)) dengan 1 API call gabungan di akhir |
| profile | Selesai | `ProfileController` fetch-based (`dosen`, `load()`, `refresh()`) menggantikan `dosenStream()`; `changePassword` sekarang panggil `POST /api/auth/change-password` (endpoint baru di backend) |
| app/app.dart + main.dart | Selesai | Firebase.initializeApp & Crashlytics hook dihapus; `_AuthGate` baru di `app/app.dart` cek `SessionService.instance.load()` async (sebelumnya sinkron via `FirebaseAuth.instance.currentUser`) |
| home | Selesai | header profil pakai `ProfileController.dosen` langsung (bukan StreamBuilder), body dibungkus `RefreshIndicator` |
| jadwal | Selesai | `ApiJadwalRepository.fetchJadwal()` -> `GET /api/jadwal-mengajar`; `JadwalMengajar.fromMap` baca snake_case (`mata_kuliah`, `jam_mulai`, dst) dari satu `Map` (bukan `id` terpisah lagi). `JadwalController` fetch-based (`jadwalList`/`load()`/`refresh()`), page pakai `RefreshIndicator`. **Catatan penting**: `nilai` dan `presensi` (sudah dimigrasi paralel oleh sesi lain, lihat baris di bawah) memakai `JadwalRepository.watchJadwal()` (Stream, lewat `.first`) dan instantiate `FirebaseJadwalRepository()` langsung di controller masing-masing — supaya tidak menyentuh file di luar scope (`features/nilai/`, `features/presensi/`), kontrak `watchJadwal()` dipertahankan di `domain/jadwal_repository.dart` (mengembalikan `Stream.fromFuture(fetchJadwal())`) dan `FirebaseJadwalRepository` dipertahankan sebagai subclass kosong dari `ApiJadwalRepository` di `data/jadwal_repository.dart`. Sudah diverifikasi lewat `flutter analyze` (bersih, 0 issue) bahwa kombinasi ini tetap kompatibel dengan `nilai`/`presensi`. |
| nilai | Selesai | `ApiNilaiRepository` (`GET /api/nilai?kelas=X`, `PUT /api/nilai/{kelas}/{mahasiswaUid}`, `GET /api/mahasiswa?kelas=X` + fallback client-side ke `GET /api/mahasiswa` kalau kosong); `_sanitize` (slugify kelas jadi doc-ID Firestore) dihapus total — `kelas` dikirim apa adanya ke query param & body, cuma di-`Uri.encodeComponent()` oleh `ApiPaths.nilaiItem()` saat jadi bagian URL path; `NilaiController` jadi fetch-based (`kelasList`/`nilaiList`/`mahasiswaList`, `isLoading`/`isLoadingDetail`/`isSaving`, `load()`/`refresh()`/`loadDetail()`/`refreshDetail()`), kelas list tetap derive dari `JadwalRepository.watchJadwal()` (fitur `jadwal` belum dimigrasi, jadi diambil one-shot via `.first` tanpa mengubah `features/jadwal/`); `NilaiPage`/`DetailNilaiPage` StreamBuilder -> state controller + `RefreshIndicator`+`AlwaysScrollableScrollPhysics`, form nilai di-populate sekali lewat guard `_controllersInitialized` (bukan setiap tick stream) |
| presensi | Selesai | `ApiPresensiRepository` (`GET /api/presensi?kelas=X&pertemuan=Y`, `PUT /api/presensi/{kelas}/{pertemuan}/{mahasiswaUid}`, fallback mahasiswa-by-kelas sama seperti nilai, kode fallback tetap diduplikasi antara `ApiNilaiRepository`/`ApiPresensiRepository` sesuai struktur lama); `_sanitize` dihapus, encoding cukup lewat `ApiPaths.presensiItem()`; dicek bug lama side-effect-in-build `_localKet` di `presensi_detail_page.dart` — **sudah diperbaiki di refactor sebelumnya** (state `_localKet` sudah dipindah ke `PresensiController`, diubah lewat `setKeterangan()` yang dipanggil dari `onChanged` dropdown, bukan dimutasi langsung di `StreamBuilder.builder`), jadi tidak ada regresi untuk diperbaiki ulang — cuma dikonversi dari `watchMahasiswa`/`watchDetail` (Stream+listen) jadi `loadMahasiswa`/`loadDetail` (Future) dengan perilaku sama |
| bimbingan | Selesai | `ApiBimbinganRepository.fetchBimbingan()` -> `GET /api/mahasiswa?dosen_pembimbing_uid={uid}` (uid dari `SessionService`), sort client-side by nama dipertahankan. `MahasiswaBimbingan.fromMap` baca `photo_url` snake_case. `BimbinganController` fetch-based (`bimbinganList`/`isLoading`/`errorMessage`/`load()`/`refresh()`), filter angkatan (`setAngkatan`/`filter()`) dipertahankan persis. `detail_bimbingan_page.dart` tidak disentuh (murni terima entity `MahasiswaBimbingan` via constructor, tidak pernah ada Firestore call). |
| informasi | Selesai | `ApiInformasiRepository.fetchInformasi()` -> `GET /api/informasi` (global, sudah `orderBy tanggal desc` di backend). `Informasi.fromMap` parse `tanggal` (ISO string via `DateTime.tryParse`) dan `gambar_url` snake_case, `cloud_firestore`/`Timestamp` dihapus total dari entity. `informasi_detail_page.dart` tidak disentuh (tidak ada Firestore call). |
| notifikasi | Selesai | `ApiNotifikasiRepository.fetchNotifikasi()` -> `GET /api/notifikasi` (auto-scope uid+role dosen di backend); `markAsRead(int id)` -> `POST /api/notifikasi/{id}/read`. `Notifikasi.id` diubah tipe dari `String` (dulu doc id Firestore) jadi `int` (field `id` dari Laravel) supaya cocok dengan `ApiPaths.notifikasiRead(int id)`; `notifikasi_detail_page.dart` tetap kompatibel tanpa perlu diubah karena cuma meneruskan `notifikasi.id` ke `markAsRead`. |
| bantuan | Selesai | `ApiBantuanRepository.kirimMasukan()` -> `POST /api/masukan` body `{kategori, pesan}` (uid diturunkan dari JWT server-side — dikonfirmasi lewat `MasukanController.php`: `BaseCrudController` dengan `ownerColumn = 'uid'`, `fillable = ['kategori','pesan']`, `writeRoles = ['dosen']`, tidak ada kejutan/perbedaan dari asumsi awal). `Masukan` domain entity dibersihkan dari `cloud_firestore`/`Timestamp` (entity ini tidak dipakai di jalur data manapun — repository create-only tidak pernah mengonstruksinya — tapi tetap dibersihkan supaya valid tanpa dependency Firebase). |
| Hapus dependency Firebase dari `pubspec.yaml` | Selesai | lihat daftar di bawah |
| Hapus `firebase_options.dart` | Selesai | file dihapus, `google-services.json` dan `fcm_service.dart` juga dihapus |
| Bersihkan `android/app/build.gradle.kts` (plugin google-services/crashlytics) | Selesai | plugin & dependency Firebase dihapus dari `build.gradle.kts`/`settings.gradle.kts` |
| `flutter analyze` bersih | Selesai | `flutter analyze` penuh atas seluruh project: "No issues found!" (termasuk `jadwal`, `bimbingan`, `informasi`, `notifikasi`, `bantuan` yang baru dimigrasi di sesi ini, plus `nilai`/`presensi` yang dimigrasi paralel oleh sesi lain) |

## Peta Endpoint (Firestore lama -> Laravel baru)

| Fitur | Lama (Firestore) | Baru (Laravel) |
|---|---|---|
| auth | `dosen` (cek existensi utk reset), `FirebaseAuth` | `POST /api/auth/login` (role=dosen), `POST /api/auth/forgot-password`, `POST /api/auth/reset-password` |
| profile | `dosen/{uid}` + Firebase Auth `updateDisplayName`/`updatePassword` | `GET/PUT /api/dosen/{uid}`, `POST /api/auth/change-password` (baru) |
| jadwal | `jadwal_mengajar where uid==` | `GET /api/jadwal-mengajar` |
| nilai | `nilai/{kelasId}/mahasiswa` (subcollection), `users where kelas==` + fallback | `GET /api/nilai?kelas=X`, `PUT /api/nilai/{kelas}/{mahasiswaUid}`, `GET /api/mahasiswa?kelas=X` + fallback client-side |
| presensi | `presensi/{kelasId}/{pertemuanId}` (subcollection), `users where kelas==` + fallback | `GET /api/presensi?kelas=X&pertemuan=Y`, `PUT /api/presensi/{kelas}/{pertemuan}/{mahasiswaUid}`, `GET /api/mahasiswa?kelas=X` + fallback client-side |
| bimbingan | `users where dosenPembimbing==uid` | `GET /api/mahasiswa?dosen_pembimbing_uid={uid}` |
| informasi | `informasi orderBy tanggal desc` (global) | `GET /api/informasi` |
| notifikasi | `notifikasi where uid== orderBy createdAt desc` + markAsRead | `GET /api/notifikasi`, `POST /api/notifikasi/{id}/read` |
| bantuan | `masukan` (create only) | `POST /api/masukan` |
| FCM token | Firestore `dosen.fcmToken` | dihapus total (FCM dihapus) |

## Dependency Berubah (`pubspec.yaml`)

- **Dihapus**: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_messaging`, `firebase_crashlytics`, `firebase_analytics`, `google_sign_in`.
- **Ditambah**: `flutter_secure_storage: ^9.2.2`, `uuid: ^4.5.1` (tidak dipakai langsung karena dosen tidak self-register, tapi disertakan untuk konsistensi/future use).
- **Dipertahankan**: `http`, `image_picker`, `flutter_local_notifications`, `timezone`, `provider`, `cupertino_icons`.

## Pola Konversi per Fitur (sama seperti `sistem_akademik`)

- **domain**: entity tetap sama field-nya (camelCase), `fromMap` diubah membaca key JSON snake_case dari Laravel.
- **data**: `FirebaseXRepository` -> `ApiXRepository` (`ApiClient.get/post/put`, `Future`), scoping `uid` dihapus dari query (backend auto-scope lewat token JWT untuk resource milik sendiri; untuk resource lintas-user seperti daftar mahasiswa, filter dikirim eksplisit sebagai query param).
- **presentation/controllers**: expose state (`List<T>`/`T?`, `isLoading`, `errorMessage`), method `load()`/`refresh()`.
- **presentation/pages**: `StreamBuilder` -> baca state controller langsung + `RefreshIndicator`.

## Perubahan di `siakad-backend` (Laravel)

- Tambah `AuthController@changePassword` + route `POST /api/auth/change-password` (JWT auth, verifikasi `old_password` via `Hash::check`, update ke `Hash::make(new_password)`) — sudah diuji via curl, berfungsi (termasuk kasus password lama salah -> 400).
- Sudah diverifikasi: `MahasiswaController@index` mendukung `?kelas=` dan `?dosen_pembimbing_uid=` (dipakai nilai/presensi/bimbingan), `NilaiController@index`/`PresensiController@index` mendukung `?kelas=`/`?pertemuan=` untuk role dosen.
- Sudah diuji: path dengan spasi (`Mobile Computing A1`) di-encode lewat `Uri.encodeComponent` dan diterima benar oleh Laravel routing.

## Catatan Verifikasi

Tidak ada emulator/device Flutter di lingkungan ini — verifikasi lewat `flutter analyze` + `curl` terhadap `siakad-backend` yang berjalan. UI aktual, navigasi, dan `image_picker` perlu diuji manual oleh user di emulator/device, dengan `ApiConfig.baseUrl` (`lib/core/constants/api_config.dart`) disesuaikan ke alamat backend.

### Hasil verifikasi final (setelah kedua agent migrasi selesai)

- `flutter pub get`: sukses, tidak ada dependency Firebase yang tersisa.
- `flutter analyze`: **"No issues found!"** (bersih, 0 issue) atas seluruh project setelah kedua agent (jadwal/bimbingan/informasi/notifikasi/bantuan, dan nilai/presensi) selesai digabung.
- Grep `firebase|cloud_firestore|google_sign_in|firestore|crashlytics|fcm` di `lib/`, `pubspec.yaml`, `android/app/build.gradle.kts`, `android/settings.gradle.kts`: **0 match** (setelah `FirebaseJadwalRepository` — nama shim kompatibilitas kosong, bukan dependency Firebase sungguhan — diganti langsung jadi `ApiJadwalRepository()` di `NilaiController`/`PresensiController` supaya tidak ada lagi penamaan yang menyesatkan).
- `android/app/google-services.json`, `lib/firebase_options.dart`, `lib/core/services/fcm_service.dart`: dikonfirmasi sudah tidak ada.
- Smoke test `curl` terhadap `siakad-backend` (server lokal aktif) sebagai dosen:
  - Register + login dosen -> `200`, dapat JWT.
  - `GET /api/jadwal-mengajar` -> `200 []` (akun baru, belum ada data — sesuai ekspektasi).
  - `GET /api/mahasiswa?dosen_pembimbing_uid=...` -> `200 []`.
  - `GET /api/mahasiswa?kelas=Mobile Computing A1` (kelas mengandung spasi, di-`urlencode`) -> `200`.
  - `GET /api/informasi`, `GET /api/notifikasi` -> `200`.
  - `POST /api/masukan` -> `201`, tersimpan dengan `uid` dari token.
  - `POST /api/auth/change-password` dengan password lama salah -> `400 "Password lama salah"`; dengan password benar -> `200`, lalu login ulang dengan password baru berhasil (`200`).
  - `PUT /api/nilai/{kelas}/{mahasiswaUid}` dengan `kelas="Mobile Computing A1"` (path di-encode) -> `200`, data tersimpan dengan kolom `kelas` tetap string asli (tidak ter-slugify).
  - `PUT /api/presensi/{kelas}/{pertemuan}/{mahasiswaUid}` body `{keterangan: "Hadir"}` -> `200`; dikonfirmasi field Flutter (`ApiPresensiRepository.simpanPresensi`) mengirim `nim`/`nama`/`keterangan` persis sesuai validator backend.
- Data uji (akun dosen/mahasiswa test) dibuat khusus untuk smoke test dan tidak memengaruhi data produksi/seed.
