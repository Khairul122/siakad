<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('presensi', function (Blueprint $table) {
            $table->id();
            $table->string('kelas', 100);
            $table->string('pertemuan', 50);
            $table->string('mahasiswa_uid', 128);
            $table->string('nim', 50)->default('');
            $table->string('nama')->default('');
            $table->enum('keterangan', ['Hadir', 'Izin', 'Sakit', 'Alpha'])->default('Alpha');
            $table->timestamp('updated_at')->useCurrent()->useCurrentOnUpdate();

            $table->foreign('mahasiswa_uid')->references('uid')->on('mahasiswa')->cascadeOnDelete();
            $table->unique(['kelas', 'pertemuan', 'mahasiswa_uid']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('presensi');
    }
};
