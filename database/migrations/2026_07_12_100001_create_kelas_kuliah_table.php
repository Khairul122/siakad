<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('kelas_kuliah', function (Blueprint $table) {
            $table->id();
            $table->foreignId('mata_kuliah_id')->constrained('mata_kuliah')->cascadeOnDelete();
            $table->string('dosen_uid', 128)->nullable();
            $table->string('nama_kelas', 50)->default('A');
            $table->string('hari', 20);
            $table->string('jam_mulai', 10);
            $table->string('jam_selesai', 10);
            $table->string('ruangan', 100)->default('');
            $table->unsignedSmallInteger('kuota')->default(40);
            $table->string('tahun_akademik', 20);
            $table->string('semester', 20);
            $table->timestamps();

            $table->foreign('dosen_uid')->references('uid')->on('dosen')->nullOnDelete();
            $table->unique(['mata_kuliah_id', 'nama_kelas', 'tahun_akademik', 'semester'], 'kelas_kuliah_unik');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('kelas_kuliah');
    }
};
