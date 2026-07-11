# SIAKAD Backend

REST API Laravel untuk Sistem Informasi Akademik, dibangun langsung dari skema `siakad.sql` (lihat `database/siakad.sql`). Autentikasi memakai JWT mandiri (`tymon/jwt-auth`) — register/login sendiri, tidak bergantung pada Firebase. Dokumentasi interaktif memakai `darkaonline/l5-swagger`.

## Menjalankan Project

```bash
composer install
cp .env.example .env
php artisan key:generate
```

Sesuaikan koneksi database di `.env` (`DB_DATABASE=siakad`, dst), lalu buat database dan generate JWT secret:

```bash
mysql -u root -p -e "CREATE DATABASE siakad CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
php artisan migrate
php artisan jwt:secret
```

Jalankan server:

```bash
php artisan serve
```

Dokumentasi Swagger tersedia di `http://localhost:8000/api/documentation` (regenerasi manual dengan `php artisan l5-swagger:generate` setelah mengubah anotasi di `app/Http/Controllers/Api/**` atau `app/Swagger/**`).

## Autentikasi

- `POST /api/auth/register` — body `{ role: "mahasiswa"|"dosen", uid, nama, email, password, nim?/nip? }`
- `POST /api/auth/login` — body `{ role, email, password }` → `access_token` (JWT, berlaku sesuai `JWT_TTL` di `.env`, default 1440 menit)
- Semua endpoint lain butuh header `Authorization: Bearer <token>`
- `POST /api/auth/forgot-password` / `POST /api/auth/reset-password` — alur OTP; **belum ada integrasi pengiriman email nyata**, OTP dikembalikan langsung di response saat `APP_ENV` bukan `production` (`otp_dev_only`).

## Struktur

- `app/Models/` — 16 model Eloquent, satu per tabel `siakad.sql`.
- `app/Http/Controllers/Api/BaseCrudController.php` — pola CRUD generik (dipakai `JadwalKuliah`, `JadwalMengajar`, `Absensi`, `Informasi`, `Kegiatan`, `Masukan`, `Khs`); scoping akses per `ownerColumn` + role.
- Controller custom untuk tabel dengan logic khusus: `Mahasiswa`, `Dosen` (uid sebagai primary key), `Krs` (nested `krs_mata_kuliah`), `Nilai`/`Presensi` (upsert komposit key), `Tagihan` (transisi status konfirmasi/lunas), `Notifikasi` (scoped per `tipe_user`).
- `app/Swagger/*.php` — anotasi OpenAPI (PHP 8 Attributes, `#[OpenApi\Attributes\...]`) untuk skema & endpoint tiap resource, terpisah dari controller supaya controller tetap ringkas.

## Catatan Penting

- Kolom `password` pada `mahasiswa`/`dosen` ditambahkan khusus untuk backend ini (tidak ada di data Firestore asli aplikasi Flutter) — lihat catatan di `database/siakad.sql`.
- Tabel `presensi`/`nilai` memakai key komposit (`kelas`+`pertemuan`+`mahasiswa_uid` / `kelas`+`mahasiswa_uid`) mengikuti struktur asli, bukan `id` auto-increment sebagai identifier utama di endpoint.
- Guard JWT ganda: `mahasiswa` dan `dosen` (lihat `config/auth.php`), diresolusi otomatis lewat middleware `jwt.multi` (`app/Http/Middleware/JwtMultiGuard.php`) — mencoba kedua guard sampai salah satu berhasil memverifikasi token.
