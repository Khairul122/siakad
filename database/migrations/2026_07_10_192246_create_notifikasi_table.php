<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notifikasi', function (Blueprint $table) {
            $table->id();
            $table->string('uid', 128);
            $table->enum('tipe_user', ['Mahasiswa', 'Dosen']);
            $table->string('judul');
            $table->text('isi')->nullable();
            $table->boolean('dibaca')->default(false);
            $table->timestamp('created_at')->useCurrent();

            $table->index('uid', 'idx_notifikasi_uid');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notifikasi');
    }
};
