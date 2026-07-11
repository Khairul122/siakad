<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('krs_mata_kuliah', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('krs_id');
            $table->string('nama');
            $table->string('kode', 20)->default('');
            $table->string('sks', 10)->default('');
            $table->string('kelas', 50)->default('');
            $table->string('hari', 20)->default('');
            $table->string('pukul', 30)->default('');
            $table->string('ruang', 100)->default('');
            $table->string('status', 30)->default('');

            $table->foreign('krs_id')->references('id')->on('krs')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('krs_mata_kuliah');
    }
};
