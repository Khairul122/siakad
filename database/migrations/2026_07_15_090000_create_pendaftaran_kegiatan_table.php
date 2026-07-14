<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('pendaftaran_kegiatan', function (Blueprint $table) {
            $table->id();
            $table->foreignId('kegiatan_id')->constrained('kegiatan')->cascadeOnDelete();
            $table->string('uid', 128);
            $table->string('nama')->default('');
            $table->string('nim', 50)->default('');
            $table->string('prodi')->default('');
            $table->string('no_hp', 50)->default('');
            $table->string('status', 30)->default('Terdaftar');
            $table->timestamp('created_at')->useCurrent();

            $table->foreign('uid')->references('uid')->on('mahasiswa')->cascadeOnDelete();
            $table->unique(['kegiatan_id', 'uid'], 'uniq_pendaftaran_kegiatan_mahasiswa');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pendaftaran_kegiatan');
    }
};
