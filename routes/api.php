<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DosenController;
use App\Http\Controllers\Api\InformasiController;
use App\Http\Controllers\Api\JadwalKuliahController;
use App\Http\Controllers\Api\JadwalMengajarController;
use App\Http\Controllers\Api\KegiatanController;
use App\Http\Controllers\Api\KelasKuliahController;
use App\Http\Controllers\Api\KhsController;
use App\Http\Controllers\Api\KrsController;
use App\Http\Controllers\Api\MahasiswaController;
use App\Http\Controllers\Api\MataKuliahController;
use App\Http\Controllers\Api\MasukanController;
use App\Http\Controllers\Api\NilaiController;
use App\Http\Controllers\Api\NotifikasiController;
use App\Http\Controllers\Api\PresensiController;
use App\Http\Controllers\Api\TagihanController;
use App\Http\Controllers\Api\UploadController;
use Illuminate\Support\Facades\Route;

Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
    Route::post('forgot-password', [AuthController::class, 'forgotPassword']);
    Route::post('reset-password', [AuthController::class, 'resetPassword']);
});

Route::middleware('jwt.multi')->group(function () {
    Route::get('auth/me', [AuthController::class, 'me']);
    Route::post('auth/change-password', [AuthController::class, 'changePassword']);

    Route::apiResource('mahasiswa', MahasiswaController::class)->except(['store']);
    Route::apiResource('dosen', DosenController::class)->only(['index', 'show', 'update', 'destroy']);

    Route::apiResource('jadwal-kuliah', JadwalKuliahController::class)->only(['index', 'show']);
    Route::get('jadwal-mengajar', [JadwalMengajarController::class, 'index']);
    Route::get('jadwal-mengajar/{id}', [JadwalMengajarController::class, 'show']);

    Route::get('mata-kuliah', [MataKuliahController::class, 'index']);
    Route::get('mata-kuliah/{id}', [MataKuliahController::class, 'show']);
    Route::get('kelas-kuliah', [KelasKuliahController::class, 'index']);
    Route::get('kelas-kuliah/{id}', [KelasKuliahController::class, 'show']);
    Route::get('kelas-kuliah/{id}/peserta', [KelasKuliahController::class, 'peserta']);

    Route::get('krs/kuota', [KrsController::class, 'kuota']);
    Route::apiResource('krs', KrsController::class);
    Route::middleware('role:dosen')->group(function () {
        Route::post('krs/{id}/approve', [KrsController::class, 'approve']);
        Route::post('krs/{id}/reject', [KrsController::class, 'reject']);
    });

    Route::get('khs/ringkasan', [KhsController::class, 'ringkasan']);
    Route::apiResource('khs', KhsController::class)->only(['index', 'show']);

    Route::get('nilai', [NilaiController::class, 'index']);
    Route::get('nilai/{kelasKuliahId}/{mahasiswaUid}', [NilaiController::class, 'show']);
    Route::put('nilai/{kelasKuliahId}/{mahasiswaUid}', [NilaiController::class, 'upsert']);
    Route::delete('nilai/{kelasKuliahId}/{mahasiswaUid}', [NilaiController::class, 'destroy']);

    Route::get('presensi', [PresensiController::class, 'index']);
    Route::get('presensi/{kelasKuliahId}/{pertemuan}/{mahasiswaUid}', [PresensiController::class, 'show']);
    Route::put('presensi/{kelasKuliahId}/{pertemuan}/{mahasiswaUid}', [PresensiController::class, 'upsert']);
    Route::delete('presensi/{kelasKuliahId}/{pertemuan}/{mahasiswaUid}', [PresensiController::class, 'destroy']);

    Route::apiResource('tagihan', TagihanController::class);
    Route::post('tagihan/{id}/konfirmasi', [TagihanController::class, 'konfirmasi']);
    Route::post('tagihan/{id}/lunas', [TagihanController::class, 'lunas']);

    Route::apiResource('informasi', InformasiController::class);
    Route::apiResource('kegiatan', KegiatanController::class);

    Route::get('notifikasi', [NotifikasiController::class, 'index']);
    Route::post('notifikasi', [NotifikasiController::class, 'store']);
    Route::post('notifikasi/{id}/read', [NotifikasiController::class, 'markAsRead']);
    Route::delete('notifikasi/{id}', [NotifikasiController::class, 'destroy']);

    Route::apiResource('masukan', MasukanController::class);

    Route::post('uploads', [UploadController::class, 'store']);
});
