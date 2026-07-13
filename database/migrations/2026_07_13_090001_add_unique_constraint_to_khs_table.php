<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('khs', function (Blueprint $table) {
            $table->unique(['uid', 'tahun_akademik', 'semester', 'kode'], 'khs_unik_per_matkul');
        });
    }

    public function down(): void
    {
        Schema::table('khs', function (Blueprint $table) {
            $table->dropUnique('khs_unik_per_matkul');
        });
    }
};
