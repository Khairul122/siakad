<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('absensi', function (Blueprint $table) {
            $table->id();
            $table->string('uid', 128);
            $table->enum('matkul', [
                'algoritma',
                'basis_data',
                'mobile_computing',
                'rekayasa_web',
                'sistem_operasi',
                'statistik',
            ]);
            $table->string('pertemuan', 50);
            $table->date('tanggal');
            $table->string('keterangan')->default('');
            $table->string('ruangan', 100)->default('');
            $table->string('dosen')->default('');

            $table->foreign('uid')->references('uid')->on('mahasiswa')->cascadeOnDelete();
            $table->index(['uid', 'matkul'], 'idx_absensi_uid_matkul');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('absensi');
    }
};
