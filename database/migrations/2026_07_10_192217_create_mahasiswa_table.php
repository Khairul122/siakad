<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('mahasiswa', function (Blueprint $table) {
            $table->string('uid', 128)->primary();
            $table->string('nama');
            $table->string('nim', 50)->unique()->nullable();
            $table->string('email')->unique();
            $table->string('password');
            $table->string('no_hp', 50)->default('');
            $table->string('tanggal_lahir', 50)->default('');
            $table->text('alamat')->nullable();
            $table->string('photo_url', 500)->default('');
            $table->string('kelas', 100)->default('');
            $table->string('angkatan', 20)->default('');
            $table->string('prodi')->default('');
            $table->string('dosen_pembimbing_uid', 128)->nullable();
            $table->string('fcm_token')->nullable();
            $table->timestamps();

            $table->foreign('dosen_pembimbing_uid')->references('uid')->on('dosen')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('mahasiswa');
    }
};
