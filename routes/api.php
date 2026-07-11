<?php

use App\Http\Controllers\Api\AbsensiController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DosenController;
use App\Http\Controllers\Api\InformasiController;
use App\Http\Controllers\Api\JadwalKuliahController;
use App\Http\Controllers\Api\JadwalMengajarController;
use App\Http\Controllers\Api\KegiatanController;
use App\Http\Controllers\Api\KhsController;
use App\Http\Controllers\Api\KrsController;
use App\Http\Controllers\Api\MahasiswaController;
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

    Route::apiResource('jadwal-kuliah', JadwalKuliahController::class);
    Route::apiResource('jadwal-mengajar', JadwalMengajarController::class);

    Route::apiResource('krs', KrsController::class);
    Route::apiResource('khs', KhsController::class);

    Route::get('nilai', [NilaiController::class, 'index']);
    Route::get('nilai/{kelas}/{mahasiswaUid}', [NilaiController::class, 'show']);
    Route::put('nilai/{kelas}/{mahasiswaUid}', [NilaiController::class, 'upsert']);
    Route::delete('nilai/{kelas}/{mahasiswaUid}', [NilaiController::class, 'destroy']);

    Route::get('presensi', [PresensiController::class, 'index']);
    Route::get('presensi/{kelas}/{pertemuan}/{mahasiswaUid}', [PresensiController::class, 'show']);
    Route::put('presensi/{kelas}/{pertemuan}/{mahasiswaUid}', [PresensiController::class, 'upsert']);
    Route::delete('presensi/{kelas}/{pertemuan}/{mahasiswaUid}', [PresensiController::class, 'destroy']);

    Route::apiResource('absensi', AbsensiController::class);

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
