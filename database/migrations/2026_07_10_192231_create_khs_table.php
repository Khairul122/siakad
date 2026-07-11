<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('khs', function (Blueprint $table) {
            $table->id();
            $table->string('uid', 128);
            $table->string('tahun_akademik', 20);
            $table->string('semester', 20);
            $table->string('kode', 20)->default('');
            $table->string('mata_kuliah');
            $table->integer('sks')->default(0);
            $table->string('kelas', 50)->default('');
            $table->decimal('tugas', 5, 2)->default(0);
            $table->decimal('uts', 5, 2)->default(0);
            $table->decimal('uas', 5, 2)->default(0);

            $table->foreign('uid')->references('uid')->on('mahasiswa')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('khs');
    }
};
