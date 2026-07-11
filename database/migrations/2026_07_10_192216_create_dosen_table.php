<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('dosen', function (Blueprint $table) {
            $table->string('uid', 128)->primary();
            $table->string('nama');
            $table->string('nip', 50)->unique()->nullable();
            $table->string('email')->unique();
            $table->string('password');
            $table->string('photo_url', 500)->default('');
            $table->string('prodi')->default('');
            $table->string('fcm_token')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('dosen');
    }
};
