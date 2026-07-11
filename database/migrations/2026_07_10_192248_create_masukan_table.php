<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('masukan', function (Blueprint $table) {
            $table->id();
            $table->string('uid', 128);
            $table->string('kategori')->default('');
            $table->text('pesan');
            $table->timestamp('created_at')->useCurrent();

            $table->foreign('uid')->references('uid')->on('dosen')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('masukan');
    }
};
