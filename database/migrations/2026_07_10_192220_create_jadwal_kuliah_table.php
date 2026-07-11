<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('jadwal_kuliah', function (Blueprint $table) {
            $table->id();
            $table->string('uid', 128);
            $table->string('hari', 20);
            $table->string('mata_kuliah');
            $table->string('jam_mulai', 10);
            $table->string('jam_selesai', 10);
            $table->string('ruangan', 100)->default('');
            $table->string('keterangan')->default('');

            $table->foreign('uid')->references('uid')->on('mahasiswa')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('jadwal_kuliah');
    }
};
