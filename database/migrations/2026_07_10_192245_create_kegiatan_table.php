<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('kegiatan', function (Blueprint $table) {
            $table->id();
            $table->string('judul');
            $table->text('deskripsi')->nullable();
            $table->dateTime('tanggal')->nullable();
            $table->string('gambar_url', 500)->default('');
            $table->string('lokasi')->default('');
            $table->string('status', 50)->default('');
            $table->string('pemateri')->default('');
            $table->string('kuota', 20)->default('');
            $table->timestamp('created_at')->useCurrent();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('kegiatan');
    }
};
