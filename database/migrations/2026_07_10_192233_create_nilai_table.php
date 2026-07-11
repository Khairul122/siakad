<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('nilai', function (Blueprint $table) {
            $table->id();
            $table->string('kelas', 100);
            $table->string('mahasiswa_uid', 128);
            $table->string('nim', 50)->default('');
            $table->string('nama')->default('');
            $table->integer('tugas')->default(0);
            $table->integer('uts')->default(0);
            $table->integer('uas')->default(0);
            $table->timestamp('updated_at')->useCurrent()->useCurrentOnUpdate();

            $table->foreign('mahasiswa_uid')->references('uid')->on('mahasiswa')->cascadeOnDelete();
            $table->unique(['kelas', 'mahasiswa_uid']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('nilai');
    }
};
