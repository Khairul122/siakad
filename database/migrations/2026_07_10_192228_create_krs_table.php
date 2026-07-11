<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('krs', function (Blueprint $table) {
            $table->id();
            $table->string('uid', 128);
            $table->string('tahun_akademik', 20);
            $table->string('semester', 20);
            $table->timestamp('created_at')->useCurrent();

            $table->foreign('uid')->references('uid')->on('mahasiswa')->cascadeOnDelete();
            $table->unique(['uid', 'tahun_akademik', 'semester']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('krs');
    }
};
